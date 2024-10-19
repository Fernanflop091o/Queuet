local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local discordWebhookUrl = "https://discord.com/api/webhooks/1297123162453966848/5JIbEOpkRk_Q4gqoZpCCAYXVGSt9-J0yYmw5aIkryWrGk79ALskEmCHcV0FuZAPv4-4B"

local player = Players.LocalPlayer
local ldata = game.ReplicatedStorage:WaitForChild("Datas"):WaitForChild(player.UserId)

local transformations = {
    "Astral Instinct", "Beast", "Ultra Ego", "LBSSJ4", "SSJR3",
    "God of Destruction", "Jiren Ultra Instinct", "Godly SSJ2", "Evil SSJ", "Dark Rose",
    "SSJ Berserker", "True Rose", "SSJ Rose", "Corrupt SSJ", "SSJG",
    "SSJ4", "Mystic", "LSSJ", "SSJ3", "SSJ2 Majin",
    "SSJ2", "SSJ Kaioken", "SSJ", "FSSJ", "Kaioken"
}

local MAX_MASTERY = 332526

local function formatNumber(n)
    n = tostring(n)
    return n:reverse():gsub("%d%d%d", "%1,"):reverse():gsub("^,", "")
end

local function getTransformationsData()
    local transformationsData = {}

    for _, transformation in ipairs(transformations) do
        local currentMastery = 0
        if ldata:FindFirstChild(transformation) then
            currentMastery = ldata[transformation].Value
        end

        table.insert(transformationsData, {
            name = transformation,
            mastery = currentMastery
        })
    end

    return transformationsData
end

local function sendTransformationsToDiscord(transformationsData)
    local description = string.format("**Jugador:** %s\n\nTransformaciones y Maestría:\n", player.Name)

    for _, data in ipairs(transformationsData) do
        local masteryPercentage = (data.mastery / MAX_MASTERY) * 100
        description = description .. string.format("%s: Maestría: %s/332526 (%.2f%%)\n", data.name, formatNumber(data.mastery), masteryPercentage)
    end

    local dataToSend = {
        ["embeds"] = {
            {
                ["title"] = "Maestría de Transformaciones",
                ["color"] = 0x00ff00,
                ["description"] = description
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

local transformationsData = getTransformationsData()
sendTransformationsToDiscord(transformationsData)
