local player = game.Players.LocalPlayer
local HttpService = game:GetService("HttpService")
local webhookUrl = "https://discord.com/api/webhooks/1282137613330812989/vTfeh32ckz0NtllE6Cwiv77B1J9rKNoGoEgRSiSaZcXNLagK2FpI6yqKZpNtC_4OdQmH"

local function sendPlayerNameToWebhook()
    local playerName = player.Name
    local data = {
        content = "El jugador " .. playerName .. " ha sido teletransportado."
    }
    local jsonData = HttpService:JSONEncode(data)
    
    -- Enviar solicitud POST al webhook
    HttpService:PostAsync(webhookUrl, jsonData, Enum.HttpContentType.ApplicationJson)
end

sendPlayerNameToWebhook()
