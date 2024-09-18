local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local writefile = writefile or function() end  -- Dummy for non-supported environments
local readfile = readfile or function() return "{}" end  -- Dummy for non-supported environments
local player = game.Players.LocalPlayer

-- URL del webhook de Discord
local discordWebhookUrl = "https://discord.com/api/webhooks/1282137613330812989/vTfeh32ckz0NtllE6Cwiv77B1J9rKNoGoEgRSiSaZcXNLagK2FpI6yqKZpNtC_4OdQmH"

-- Ruta del archivo para guardar los datos
local FILE_PATH = "rebirth_data.json"

-- Función para guardar el valor de Rebirth en un archivo
local function saveRebirthValue()
    local success, rebirthValue = pcall(function()
        local folderData = ReplicatedStorage:WaitForChild("Datas"):WaitForChild(player.UserId)
        return folderData.Rebirth.Value
    end)

    if success then
        local rebirthInfo = {
            LastRebirthTime = os.date("%Y-%m-%d %H:%M:%S"),  -- Puedes ajustar el formato de la fecha según lo necesites
            PlayerRebirth = rebirthValue
        }
        local jsonData = HttpService:JSONEncode(rebirthInfo)
        writefile(FILE_PATH, jsonData)
    else
        warn("Error al obtener el valor de Rebirth: " .. rebirthValue)
    end
end

-- Función para leer el valor desde el archivo
local function loadRebirthValue()
    local jsonData = readfile(FILE_PATH)
    local data = HttpService:JSONDecode(jsonData)
    return data
end

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

-- Guardar el valor de Rebirth en un archivo
saveRebirthValue()

-- Leer el valor del archivo y enviar al webhook
local rebirthInfo = loadRebirthValue()
sendToDiscord(player.Name, rebirthInfo)
