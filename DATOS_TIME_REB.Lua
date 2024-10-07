local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

local FILE_PATH = "LastRebirthTime.txt"
local discordWebhookUrl = "https://discord.com/api/webhooks/1286118077829742593/KbfczS76YlMW7x_Q9vbA60XRE78_xc9uvDZOGkzLU5AEfP-fH1iX-_P6YzBg7d6-WiJn"

local previousRebirthValue = 0

-- Función para enviar datos a Discord
local function sendToDiscord(message)
    local data = {
        content = message -- Mensaje a enviar
    }

    local jsonData = HttpService:JSONEncode(data)

    local response = http_request({
        Url = discordWebhookUrl,
        Method = "POST",
        Headers = {
            ["Content-Type"] = "application/json"
        },
        Body = jsonData
    })

    if response.StatusCode == 200 then
        print("Mensaje enviado a Discord: " .. message)
    else
        warn("Error al enviar a Discord: " .. response.StatusCode)
    end
end

-- Función para guardar el tiempo del último rebirth (formato hora:minuto)
local function saveRebirthTime()
    local currentTime = os.time()
    local success, err = pcall(function()
        writefile(FILE_PATH, tostring(currentTime)) -- Guardar el tiempo actual (en formato UNIX) en el archivo
    end)
    if not success then
        warn("Error al guardar el tiempo de rebirth: " .. err)
    end
end

-- Función para cargar el tiempo del último rebirth desde el archivo
local function loadRebirthTime()
    if isfile(FILE_PATH) then
        local success, lastRebirthTime = pcall(function()
            return tonumber(readfile(FILE_PATH)) -- Leer y convertir a número
        end)
        if success and lastRebirthTime then
            return lastRebirthTime
        else
            warn("Error al leer el archivo de tiempo de rebirth.")
        end
    end
    return os.time() -- Si no hay archivo, devolver el tiempo actual
end

-- Función para calcular el tiempo transcurrido entre dos rebirths (en minutos y segundos)
local function calculateElapsedTime(lastRebirthTime)
    local currentTime = os.time()
    local elapsedTime = currentTime - lastRebirthTime -- Tiempo en segundos entre rebirths

    local minutes = math.floor(elapsedTime / 60) -- Calcular minutos
    local seconds = elapsedTime % 60 -- Calcular segundos restantes

    local formattedTime = string.format("%d minutos y %02d segundos", minutes, seconds)
    return formattedTime
end

-- Función para obtener la hora formateada
local function getFormattedTime(timestamp)
    local date = os.date("*t", timestamp)
    return string.format("%02d:%02d:%02d", date.hour, date.min, date.sec)
end

-- Conexión para detectar cambios en el rebirth
RunService.Stepped:Connect(function()
    local player = Players.LocalPlayer
    local playerStats = player.Character and player.Character:FindFirstChild("Stats")
    local currentRebirthValue = playerStats and playerStats:FindFirstChild("Rebirth") and playerStats.Rebirth.Value or 0

    if currentRebirthValue > previousRebirthValue then
        -- Cargar el último rebirth desde el archivo
        local lastRebirthTime = loadRebirthTime()

        -- Obtener la hora del último rebirth formateada
        local lastRebirthFormatted = getFormattedTime(lastRebirthTime)

        -- Calcular el tiempo transcurrido desde el último rebirth
        local elapsedTime = calculateElapsedTime(lastRebirthTime)

        -- Obtener la hora del nuevo rebirth formateada
        local currentRebirthFormatted = getFormattedTime(os.time())

        -- Enviar el mensaje a Discord con la hora del último rebirth, la hora del nuevo rebirth, y el tiempo transcurrido
        local message = string.format(
            "Último rebirth fue a las %s. Nuevo rebirth ocurrió a las %s. Tiempo transcurrido: %s.",
            lastRebirthFormatted,
            currentRebirthFormatted,
            elapsedTime
        )
        sendToDiscord(message)

        -- Guardar el nuevo tiempo de rebirth
        saveRebirthTime()

        -- Actualizar el valor del rebirth
        previousRebirthValue = currentRebirthValue
    end
end)
