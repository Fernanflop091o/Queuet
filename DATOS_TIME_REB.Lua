local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

local FILE_PATH = "RebirthTimes.json"
local discordWebhookUrl = "https://discord.com/api/webhooks/1286118077829742593/KbfczS76YlMW7x_Q9vbA60XRE78_xc9uvDZOGkzLU5AEfP-fH1iX-_P6YzBg7d6-WiJn"

local previousRebirthValue = 0
local lastRebirthTime = 0
local elapsedTime = 0

-- Enviar el mensaje a Discord formateado en minutos y segundos
local function sendToDiscord(elapsedTimeFormatted)
    local data = {
        content = "Tiempo transcurrido desde el último rebirth: " .. elapsedTimeFormatted
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

-- Guardar el tiempo de rebirth en un archivo JSON
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

-- Cargar el último tiempo de rebirth
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

-- Calcular el tiempo transcurrido desde el último rebirth
local function calculateElapsedTime()
    local currentTime = os.time()
    return currentTime - lastRebirthTime
end

-- Formatear el tiempo transcurrido en minutos y segundos
local function formatElapsedTime(elapsedTime)
    local minutes = math.floor(elapsedTime / 60)
    local seconds = elapsedTime % 60
    return string.format("%02d minutos y %02d segundos", minutes, seconds)
end

-- Función principal para rastrear los rebirths
local function trackRebirth()
    while true do
        local player = Players.LocalPlayer
        local playerStats = player.Character and player.Character:FindFirstChild("Stats")
        local currentRebirthValue = playerStats and playerStats:FindFirstChild("Rebirth") and playerStats.Rebirth.Value or 0

        -- Si el jugador ha hecho un nuevo rebirth
        if currentRebirthValue > previousRebirthValue then
            lastRebirthTime = loadLastRebirthTime() or os.time()
            elapsedTime = calculateElapsedTime()

            -- Formatear el tiempo transcurrido y enviarlo a Discord
            local elapsedTimeFormatted = formatElapsedTime(elapsedTime)
            sendToDiscord(elapsedTimeFormatted)
            saveRebirthTime()
            previousRebirthValue = currentRebirthValue

        -- Actualizar el valor previo si disminuye
        elseif currentRebirthValue < previousRebirthValue then
            previousRebirthValue = currentRebirthValue
        end

        wait(1) -- Esperar un segundo entre cada verificación
    end
end

-- Contar el tiempo en segundo plano usando RunService
RunService.Heartbeat:Connect(function()
    if lastRebirthTime > 0 then
        elapsedTime = calculateElapsedTime()
    end
end)

spawn(trackRebirth)
