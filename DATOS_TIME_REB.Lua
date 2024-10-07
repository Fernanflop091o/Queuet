local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

local FILE_PATH = "RebirthTimes.json"
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

-- Función para guardar la hora del rebirth en un archivo JSON
local function saveRebirthTime()
    local currentTime = os.date("*t")
    local success, err = pcall(function()
        local rebirthData = {}
        if isfile(FILE_PATH) then
            -- Si ya existe el archivo, cargar los datos existentes
            rebirthData = HttpService:JSONDecode(readfile(FILE_PATH))
        end

        -- Guardar la nueva entrada con la hora actual del rebirth
        table.insert(rebirthData, {hour = currentTime.hour, min = currentTime.min, sec = currentTime.sec})
        
        -- Escribir el archivo actualizado
        writefile(FILE_PATH, HttpService:JSONEncode(rebirthData))
    end)
    
    if not success then
        warn("Error al guardar el tiempo de rebirth: " .. err)
    end
end

-- Función para cargar el tiempo del último rebirth desde el archivo JSON
local function loadLastRebirthTime()
    if isfile(FILE_PATH) then
        local success, rebirthData = pcall(function()
            return HttpService:JSONDecode(readfile(FILE_PATH)) -- Leer el archivo JSON
        end)
        if success and #rebirthData > 0 then
            return rebirthData[#rebirthData] -- Devolver el último rebirth guardado
        else
            warn("Error al leer el archivo de tiempos de rebirth.")
        end
    end
    return nil -- Si no hay datos, devolver nil
end

-- Función para calcular el tiempo transcurrido entre dos rebirths (en horas, minutos y segundos)
local function calculateElapsedTime(lastRebirthTime)
    local currentTime = os.date("*t")

    -- Convertir las horas, minutos y segundos a segundos para hacer el cálculo
    local lastRebirthInSeconds = (lastRebirthTime.hour * 3600) + (lastRebirthTime.min * 60) + lastRebirthTime.sec
    local currentTimeInSeconds = (currentTime.hour * 3600) + (currentTime.min * 60) + currentTime.sec

    local elapsedTimeInSeconds = currentTimeInSeconds - lastRebirthInSeconds

    -- Convertir el tiempo transcurrido de vuelta a horas, minutos y segundos
    local hours = math.floor(elapsedTimeInSeconds / 3600)
    local minutes = math.floor((elapsedTimeInSeconds % 3600) / 60)
    local seconds = elapsedTimeInSeconds % 60

    local formattedTime = string.format("%02d horas, %02d minutos y %02d segundos", hours, minutes, seconds)
    return formattedTime
end

-- Conexión para detectar cambios en el rebirth
RunService.Stepped:Connect(function()
    local player = Players.LocalPlayer
    local playerStats = player.Character and player.Character:FindFirstChild("Stats")
    local currentRebirthValue = playerStats and playerStats:FindFirstChild("Rebirth") and playerStats.Rebirth.Value or 0

    if currentRebirthValue > previousRebirthValue then
        -- Cargar el último rebirth guardado en el archivo JSON
        local lastRebirthTime = loadLastRebirthTime()

        if lastRebirthTime then
            -- Calcular el tiempo transcurrido desde el último rebirth
            local elapsedTime = calculateElapsedTime(lastRebirthTime)

            -- Enviar el mensaje a Discord con el tiempo transcurrido
            local message = string.format(
                "Nuevo rebirth detectado. Tiempo transcurrido desde el último rebirth: %s.",
                elapsedTime
            )
            sendToDiscord(message)
        else
            -- Si no hay rebirth previo, enviar un mensaje indicando que es el primer rebirth
            sendToDiscord("Primer rebirth detectado.")
        end

        -- Guardar el nuevo tiempo de rebirth
        saveRebirthTime()

        -- Actualizar el valor del rebirth
        previousRebirthValue = currentRebirthValue
    end
end)
