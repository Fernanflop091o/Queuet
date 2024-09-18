local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local player = game.Players.LocalPlayer

-- URL del webhook de Discord
local discordWebhookUrl = "https://discord.com/api/webhooks/1282137613330812989/vTfeh32ckz0NtllE6Cwiv77B1J9rKNoGoEgRSiSaZcXNLagK2FpI6yqKZpNtC_4OdQmH"

-- Ruta del archivo para guardar el valor de rebirths
local FILE_PATH = "rebirth_data.json"

-- Función para formatear los números con sufijos (K, M, B, etc.)
local function formatNumber(number)
    local suffixes = {"", "K", "M", "B", "T", "QD"}
    local suffix_index = 1

    while math.abs(number) >= 1000 and suffix_index < #suffixes do
        number = number / 1000.0
        suffix_index = suffix_index + 1
    end

    return string.format("%.2f%s", number, suffixes[suffix_index])
end

-- Función para enviar datos al webhook de Discord
local function sendToDiscord(name, displayName, rebirthInfo)
    local formattedRebirth = formatNumber(rebirthInfo.PlayerRebirth)  -- Formatear rebirth con sufijos
    local data = {
        ["content"] = "```\n" ..
                      "Nombre del jugador: " .. name .. "\n" ..
                      "Apodo del jugador: " .. displayName .. "\n" ..
                      "Rebirth (Formateado): " .. formattedRebirth .. "\n" ..
                      "Último Rebirth: " .. rebirthInfo.LastRebirthTime .. "\n" ..
                      "```"
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
        sendToDiscord(player.Name, player.DisplayName, rebirthInfo)  -- Enviar al webhook con apodo y rebirth formateado en un cuadro
        saveRebirthValue(newRebirthValue)  -- Actualizar el archivo con el nuevo valor
        rebirthValue = newRebirthValue  -- Actualizar el valor actual
    end
end)
