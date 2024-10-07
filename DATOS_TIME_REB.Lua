local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

local discordWebhookUrl = "https://discord.com/api/webhooks/1286118077829742593/KbfczS76YlMW7x_Q9vbA60XRE78_xc9uvDZOGkzLU5AEfP-fH1iX-_P6YzBg7d6-WiJn"

local previousRebirthValue = 0
local lastRebirthTime = tick()

local function sendToDiscord(formattedTime)
    local data = {
        content = "Tiempo transcurrido desde el último rebirth: " .. formattedTime  -- Mensaje a enviar
    }

    local success, response = pcall(function()
        local jsonData = HttpService:JSONEncode(data)
        return HttpService:PostAsync(discordWebhookUrl, jsonData, Enum.HttpContentType.ApplicationJson)
    end)

    if success then
        print("Tiempo enviado a Discord: " .. formattedTime)
    else
        warn("Error al enviar a Discord: " .. response)
    end
end

local function saveRebirthTimeFormatted(elapsedTime)
    local minutes = math.floor(elapsedTime / 60)
    local seconds = math.floor(elapsedTime % 60)
    local formattedTime = string.format("%d:%02d", minutes, seconds)

    sendToDiscord(formattedTime)  -- Enviar el tiempo a Discord
end

RunService.Stepped:Connect(function()
    local player = Players.LocalPlayer
    local playerStats = player.Character and player.Character:FindFirstChild("Stats")
    local currentRebirthValue = playerStats and playerStats:FindFirstChild("Rebirth") and playerStats.Rebirth.Value or 0

    if currentRebirthValue > previousRebirthValue then
        local currentTime = tick()
        local elapsedTime = currentTime - lastRebirthTime
        saveRebirthTimeFormatted(elapsedTime)  -- Guarda el tiempo transcurrido
        lastRebirthTime = currentTime  -- Actualiza el tiempo del último rebirth
        previousRebirthValue = currentRebirthValue  -- Guarda el nuevo valor de rebirth
    end
end)
