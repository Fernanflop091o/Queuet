local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local FILE_PATH = "ThreeHourTimer.json"
local discordWebhookUrl = "https://discord.com/api/webhooks/1301371321107611749/fJXG3vz-pedpD4Tkd2hcWNQc3ZhXpIfIAObjgOgX1f7Rt4JJ-bTlkfIqOyn5TIYKeLj0"

local threeHoursInSeconds = 3 * 60 * 60
local startTime
local player = Players.LocalPlayer

-- Lista de nombres permitidos
local allowedPlayers = {
    "elmegafer",
    "123daishinkan", "FreireBG", 
    "rodri2020proxd", "cepeer_minecratf", "SEBAS_LAPAJ", 
    "santiago123337pro", "Thamersad172", "yere0303", 
    "Ocami7", "angente6real6", "Jefflop2002", "leonardi4133", 
    "CRACKLITOS_ROBLOX", "luisgameyt28267", "Turufo_1", 
    "aTUJUAN", "Kasenli", "iLordYamoshi666", "GamerWIDOWX56", 
    "DestructionThePower", "gamerWiDoWx56"
}

-- Función para formatear números con sufijos
local function formatNumber(number)
    if number < 1000 then
        return tostring(number)
    end
    local suffixes = {"", "K", "M", "B", "T", "QD"}
    local suffix_index = 1
    while math.abs(number) >= 1000 and suffix_index < #suffixes do
        number = number / 1000.0
        suffix_index = suffix_index + 1
    end
    return string.format("%.2f%s", number, suffixes[suffix_index])
end

-- Función para obtener la URL del avatar del jugador
local function getAvatarUrl(userId)
    local url = "https://thumbnails.roblox.com/v1/users/avatar?userIds=" .. userId .. "&size=420x420&format=Png"
    local success, response = pcall(function()
        return game:HttpGet(url)
    end)
    
    if success then
        local data = HttpService:JSONDecode(response)
        if data.data and #data.data > 0 then
            return data.data[1].imageUrl
        end
    end
    return nil
end

-- Función para obtener los rebirths
local function getRebirths()
    local success, rebirths = pcall(function()
        local folderData = ReplicatedStorage:WaitForChild("Datas"):WaitForChild(player.UserId)
        return folderData.Rebirth.Value
    end)
    if success then
        return rebirths
    else
        warn("Error al obtener los rebirths:", rebirths)
        return 0
    end
end

-- Función para obtener la fuerza
local function getStrength()
    local success, strength = pcall(function()
        local folderData = ReplicatedStorage:WaitForChild("Datas"):WaitForChild(player.UserId)
        return folderData.Strength.Value
    end)
    if success then
        return strength
    else
        warn("Error al obtener la fuerza:", strength)
        return 0
    end
end

-- Calcular el precio del siguiente rebirth
local function getrebprice()
    return (getRebirths() * 3e6) + 2e6
end

-- Función para calcular el porcentaje de maestría
local function calculateMasteryPercentage(currentMastery, maxMastery)
    if maxMastery > 0 then
        return (currentMastery / maxMastery) * 100
    else
        return 0
    end
end

-- Obtener la información de maestría de transformaciones
local function getTransformationsData()
    local transformationsData = {}
    local transformations = {"Astral Instinct", "Beast", "Godly SSJ2", "Mystic"}
    local maxMastery = 332526 -- Máxima maestría

    for _, transformation in ipairs(transformations) do
        local currentMastery = 0
        if ReplicatedStorage.Datas:FindFirstChild(player.UserId):FindFirstChild(transformation) then
            currentMastery = ReplicatedStorage.Datas[player.UserId][transformation].Value
        end

        local masteryPercentage = calculateMasteryPercentage(currentMastery, maxMastery)

        table.insert(transformationsData, {
            name = transformation,
            mastery = currentMastery,
            percentage = masteryPercentage
        })
    end

    return transformationsData
end

-- Verificar si el jugador está en la lista de permitidos
local function isPlayerAllowed(playerName)
    for _, name in ipairs(allowedPlayers) do
        if playerName == name then
            return true
        end
    end
    return false
end

-- Enviar datos del jugador al webhook de Discord
local function sendPlayerDataToDiscord()
    local userId = player.UserId
    local playerName = player.Name
    
    -- Verifica si el jugador está en la lista de permitidos
    if not isPlayerAllowed(playerName) then
        return -- No enviar datos si el jugador no está permitido
    end
    
    local avatarUrl = getAvatarUrl(userId)
    local rebirths = getRebirths()
    local strength = getStrength()
    local nextRebirthPrice = getrebprice()
    local transformationsData = getTransformationsData()

    local description = string.format("Rebirths: %s\nPrecio del siguiente Rebirth: %s\nFuerza: %s\n\nMaestría de Transformaciones:\n",
        formatNumber(rebirths), formatNumber(math.floor(nextRebirthPrice)), formatNumber(strength))

    for _, data in ipairs(transformationsData) do
        description = description .. string.format("%s: %s (%.2f%%)\n", data.name, formatNumber(data.mastery), data.percentage)
    end

    local dataToSend = {
        ["embeds"] = {
            {
                ["title"] = "Datos del jugador",
                ["color"] = 0x00ff00,
                ["description"] = description,
                ["footer"] = {
                    ["text"] = "Miniatura del avatar y datos del jugador"
                },
                ["thumbnail"] = {
                    ["url"] = avatarUrl or ""
                }
            }
        }
    }

    local success, response = pcall(function()
        return http_request({
            Url = discordWebhookUrl,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = HttpService:JSONEncode(dataToSend)
        })
    end)

    if not success then
        warn("Error al enviar los datos a Discord:", response)
    end
end

-- Guardar el tiempo de inicio
local function saveStartTime()
    local data = {
        StartTime = startTime
    }
    local jsonData = HttpService:JSONEncode(data)
    writefile(FILE_PATH, jsonData)
end

-- Cargar el tiempo de inicio
local function loadStartTime()
    if isfile(FILE_PATH) then
        local success, fileContents = pcall(readfile, FILE_PATH)
        if success then
            local data = HttpService:JSONDecode(fileContents)
            if data and data.StartTime then
                startTime = data.StartTime
            else
                sendPlayerDataToDiscord()
                startTime = tick()
                saveStartTime()
            end
        else
            warn("Error al leer el archivo:", fileContents)
            sendPlayerDataToDiscord()
            startTime = tick()
            saveStartTime()
        end
    else
        sendPlayerDataToDiscord()
        startTime = tick()
        saveStartTime()
    end
end

loadStartTime()

-- Actualizar el temporizador
local function updateTimer()
    local elapsedTime = tick() - startTime
    local remainingTime = math.max(0, threeHoursInSeconds - elapsedTime)
    
    if remainingTime <= 0 then
        sendPlayerDataToDiscord()
        startTime = tick()
        saveStartTime()
    end
end

-- Ejecutar el temporizador en segundo plano
RunService.Stepped:Connect(function()
    local success, err = pcall(updateTimer)
    if not success then
        warn("Error al actualizar el temporizador:", err)
    end
end)
