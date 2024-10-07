local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

local FILE_PATH = "RebirthTimes.json"
local discordWebhookUrl = "https://discord.com/api/webhooks/1286118077829742593/KbfczS76YlMW7x_Q9vbA60XRE78_xc9uvDZOGkzLU5AEfP-fH1iX-_P6YzBg7d6-WiJn"

local previousRebirthValue = 0
local hasSentMessage = false

local function sendToDiscord(message)
    local data = {
        content = message
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
    local currentTime = os.date("*t")
    local success, err = pcall(function()
        local rebirthData = {}
        if isfile(FILE_PATH) then
            rebirthData = HttpService:JSONDecode(readfile(FILE_PATH))
        end
        table.insert(rebirthData, {hour = currentTime.hour, min = currentTime.min, sec = currentTime.sec})
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
            return rebirthData[#rebirthData]
        end
    end
    return nil
end

local function calculateElapsedTime(lastRebirthTime)
    local currentTime = os.date("*t")
    local lastRebirthInSeconds = (lastRebirthTime.hour * 3600) + (lastRebirthTime.min * 60) + lastRebirthTime.sec
    local currentTimeInSeconds = (currentTime.hour * 3600) + (currentTime.min * 60) + currentTime.sec
    local elapsedTimeInSeconds = currentTimeInSeconds - lastRebirthInSeconds
    local hours = math.floor(elapsedTimeInSeconds / 3600)
    local minutes = math.floor((elapsedTimeInSeconds % 3600) / 60)
    local seconds = elapsedTimeInSeconds % 60
    local formattedTime = string.format("%02d horas, %02d minutos y %02d segundos", hours, minutes, seconds)
    return formattedTime
end

RunService.Stepped:Connect(function()
    local player = Players.LocalPlayer
    local playerStats = player.Character and player.Character:FindFirstChild("Stats")
    local currentRebirthValue = playerStats and playerStats:FindFirstChild("Rebirth") and playerStats.Rebirth.Value or 0

    if currentRebirthValue > previousRebirthValue then
        if not hasSentMessage then
            local lastRebirthTime = loadLastRebirthTime()

            if lastRebirthTime then
                local elapsedTime = calculateElapsedTime(lastRebirthTime)
                local message = string.format(
                    "Nuevo rebirth detectado. Tiempo transcurrido desde el último rebirth: %s.",
                    elapsedTime
                )
                sendToDiscord(message)
            else
                sendToDiscord("Primer rebirth detectado.")
            end

            saveRebirthTime()
            previousRebirthValue = currentRebirthValue
            hasSentMessage = true
        end
    elseif currentRebirthValue < previousRebirthValue then
        previousRebirthValue = currentRebirthValue
        hasSentMessage = false
    end
end)
