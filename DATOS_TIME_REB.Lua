local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

local FILE_PATH = "RebirthTimes.json"
local discordWebhookUrl = "https://discord.com/api/webhooks/1286118077829742593/KbfczS76YlMW7x_Q9vbA60XRE78_xc9uvDZOGkzLU5AEfP-fH1iX-_P6YzBg7d6-WiJn"

local previousRebirthValue = 0
local lastRebirthTime = 0

local function sendToDiscord(message)
    local data = {
        content = tostring(message)
    }

    local jsonData = HttpService:JSONEncode(data)

    local success, response = pcall(function()
        return http_request({
            Url = discordWebhookUrl,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = jsonData
        })
    end)

    if not success or response.StatusCode ~= 200 then
        warn("Error al enviar a Discord: " .. (response and response.StatusCode or "Desconocido"))
    end
end

local function saveRebirthTime()
    local currentTime = os.time()
    local success, err = pcall(function()
        local rebirthData = {}
        if isfile(FILE_PATH) then
            rebirthData = HttpService:JSONDecode(readfile(FILE_PATH))
        end
        table.insert(rebirthData, {rebirthTime = currentTime})
        writefile(FILE_PATH, HttpService:JSONEncode(rebirthData))
    end)

    if not success then
        warn("Error al guardar el tiempo de rebirth: " .. err)
    end
end

local function loadLastRebirthTime()
    if isfile(FILE_PATH) then
        local success, rebirthData = pcall(function()
            return HttpService:JSONDecode(readfile(FILE_PATH))
        end)
        if success and #rebirthData > 0 then
            return rebirthData[#rebirthData].rebirthTime
        end
    end
    return nil
end

local function formatTime(seconds)
    local minutes = math.floor(seconds / 60)
    local remainingSeconds = seconds % 60
    return string.format("%02d:%02d", minutes, remainingSeconds)
end

local function trackRebirth()
    while true do
        local player = Players.LocalPlayer
        local playerStats = player.Character and player.Character:FindFirstChild("Stats")
        local currentRebirthValue = playerStats and playerStats:FindFirstChild("Rebirth") and playerStats.Rebirth.Value or 0

        if currentRebirthValue > previousRebirthValue then
            local currentTime = os.time()
            local elapsedTime = currentTime - (lastRebirthTime or currentTime)
            local formattedTime = formatTime(elapsedTime)

            -- Enviar el tiempo formateado a Discord en M:S
            sendToDiscord("Rebirth realizado! Tiempo: " .. formattedTime)

            -- Guardar el nuevo rebirth y su tiempo
            saveRebirthTime()
            lastRebirthTime = currentTime
            previousRebirthValue = currentRebirthValue
        elseif currentRebirthValue < previousRebirthValue then
            previousRebirthValue = currentRebirthValue
        end

        wait(1)  -- Evitar sobrecargar el ciclo
    end
end

-- Llamar la función para rastrear los rebirths
spawn(trackRebirth)
