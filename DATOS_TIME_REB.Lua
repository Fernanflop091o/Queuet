local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

local FILE_PATH = "RebirthTimes.json"
local discordWebhookUrl = "https://discord.com/api/webhooks/1286118077829742593/KbfczS76YlMW7x_Q9vbA60XRE78_xc9uvDZOGkzLU5AEfP-fH1iX-_P6YzBg7d6-WiJn"

local previousRebirthValue = 0
local hasSentMessage = false
local lastRebirthTime = 0
local elapsedTime = 0

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

local function calculateElapsedTime()
    local currentTime = os.time()
    elapsedTime = currentTime - lastRebirthTime
end

local function trackRebirth()
    while true do
        local player = Players.LocalPlayer
        local playerStats = player.Character and player.Character:FindFirstChild("Stats")
        local currentRebirthValue = playerStats and playerStats:FindFirstChild("Rebirth") and playerStats.Rebirth.Value or 0

        if currentRebirthValue > previousRebirthValue then
            if not hasSentMessage then
                lastRebirthTime = loadLastRebirthTime()

                if lastRebirthTime then
                    calculateElapsedTime()
                    sendToDiscord(elapsedTime)
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

        wait(1) -- Para evitar sobrecargar el bucle
    end
end

-- Contar el tiempo en segundo plano usando RunService.Stepped
RunService.Stepped:Connect(function()
    if lastRebirthTime > 0 then
        calculateElapsedTime()
    end
end)

spawn(trackRebirth)
