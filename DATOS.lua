-- Cargar el script de Afk
loadstring(game:HttpGet("https://raw.githubusercontent.com/Fernanflop091o/Queuet/refs/heads/main/Afk.lua"))()

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local player = game.Players.LocalPlayer

local discordWebhookUrl = "https://discord.com/api/webhooks/1282137613330812989/vTfeh32ckz0NtllE6Cwiv77B1J9rKNoGoEgRSiSaZcXNLagK2FpI6yqKZpNtC_4OdQmH"
local FILE_PATH = "rebirth_data.json"

local rebirthCache = {} -- Tabla para almacenar rebirths enviados

local function formatNumber(number)
    local suffixes = {"", "K", "M", "B", "T", "QD"}
    local suffix_index = 1
    while math.abs(number) >= 1000 and suffix_index < #suffixes do
        number = number / 1000.0
        suffix_index = suffix_index + 1
    end
    return string.format("%.2f%s", number, suffixes[suffix_index])
end

local function sendToDiscord(name, displayName, rebirthInfo)
    local formattedRebirth = formatNumber(rebirthInfo.PlayerRebirth)
    local data = {
        ["content"] = "```" .. 
            "Nombre del jugador: " .. name .. "\n" ..
            "Apodo del jugador: " .. displayName .. "\n" ..
            "Rebirth (Formateado): " .. formattedRebirth .. "\n" ..
            "Último Rebirth: " .. rebirthInfo.LastRebirthTime ..
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

local function saveRebirthValue(rebirthValue)
    local rebirthInfo = {
        LastRebirthTime = os.date("%Y-%m-%d %H:%M:%S"),
        PlayerRebirth = rebirthValue
    }
    local jsonData = HttpService:JSONEncode(rebirthInfo)
    local success, errorMessage = pcall(function()
        writefile(FILE_PATH, jsonData)
    end)
    if not success then
        warn("Error al guardar el valor de rebirths:", errorMessage)
    end
end

local function loadRebirthValue()
    local success, jsonData = pcall(function()
        return readfile(FILE_PATH)
    end)
    if not success then
        warn("Error al cargar el valor de rebirths:", jsonData)
        return nil
    end
    local data, decodeError = pcall(function()
        return HttpService:JSONDecode(jsonData)
    end)
    if not data then
        warn("Error al decodificar el valor de rebirths:", decodeError)
        return nil
    end
    return data
end

local folderData = ReplicatedStorage:WaitForChild("Datas"):WaitForChild(player.UserId)
local rebirthValue = folderData.Rebirth.Value
rebirthCache[player.UserId] = rebirthValue -- Inicializar el cache con el valor actual
saveRebirthValue(rebirthValue)

folderData.Rebirth.Changed:Connect(function(newRebirthValue)
    if newRebirthValue > rebirthValue then
        -- Solo actualizar si el valor es mayor
        if rebirthCache[player.UserId] ~= newRebirthValue then
            local rebirthInfo = {
                LastRebirthTime = os.date("%Y-%m-%d %H:%M:%S"),
                PlayerRebirth = newRebirthValue
            }
            sendToDiscord(player.Name, player.DisplayName, rebirthInfo)
            saveRebirthValue(newRebirthValue)
            rebirthCache[player.UserId] = newRebirthValue -- Actualizar el cache
            rebirthValue = newRebirthValue
        end
    end
end)
