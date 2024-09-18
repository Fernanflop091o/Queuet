local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local player = game.Players.LocalPlayer

-- URL del webhook de Discord
local discordWebhookUrl = "https://discord.com/api/webhooks/1282137613330812989/vTfeh32ckz0NtllE6Cwiv77B1J9rKNoGoEgRSiSaZcXNLagK2FpI6yqKZpNtC_4OdQmH"

-- Ruta del archivo para guardar el valor de rebirths
local FILE_PATH = "rebirth_data.json"

-- Función para enviar datos al webhook de Discord
local function sendToDiscord(name, rebirthInfo)
    local data = {
        ["content"] = "Nombre del jugador: " .. name .. "\nRebirth: " .. tostring(rebirthInfo.PlayerRebirth) .. "\nÚltimo Rebirth: " .. rebirthInfo.LastRebirthTime
    }

    local success, response = pcall(function()
        return http_request({
            Url = discordWebhookUrl,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = HttpService:JSONEncode(data)
        })
    end)

    if not success then
        warn("Error al enviar datos a Discord:", response)
    end
end

-- Función para guardar el valor de rebirths en un archivo
local function saveRebirthValue(rebirthValue)
    local rebirthInfo = {
        LastRebirthTime = os.date("%Y-%m-%d %H:%M:%S"),
        PlayerRebirth = rebirthValue
    }
    local jsonData = HttpService:JSONEncode(rebirthInfo)
    writefile(FILE_PATH, jsonData)
end

-- Función para cargar el valor de rebirths desde un archivo
local function loadRebirthValue()
    local jsonData = readfile(FILE_PATH)
    local data = HttpService:JSONDecode(jsonData)
    return data
end

-- Monitorizar cambios en el valor de rebirths
local folderData = ReplicatedStorage:WaitForChild("Datas"):WaitForChild(player.UserId)
local rebirthValue = folderData.Rebirth.Value
saveRebirthValue(rebirthValue)  -- Guardar el valor inicial

folderData.Rebirth.Changed:Connect(function(newRebirthValue)
    if newRebirthValue > rebirthValue then
        local rebirthInfo = {
            LastRebirthTime = os.date("%Y-%m-%d %H:%M:%S"),
            PlayerRebirth = newRebirthValue
        }
        sendToDiscord(player.Name, rebirthInfo)  -- Enviar al webhook
        saveRebirthValue(newRebirthValue)  -- Actualizar el archivo con el nuevo valor
        rebirthValue = newRebirthValue  -- Actualizar el valor actual
    end
end)
