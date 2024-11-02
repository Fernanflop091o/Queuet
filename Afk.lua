local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local FILE_PATH = "ThreeHourTimer.json"
local allowedWebhookUrl = "https://discord.com/api/webhooks/1301371321107611749/fJXG3vz-pedpD4Tkd2hcWNQc3ZhXpIfIAObjgOgX1f7Rt4JJ-bTlkfIqOyn5TIYKeLj0"
local anyPlayerWebhookUrl = "https://discord.com/api/webhooks/1302166989758005259/XWp0LQENRsRjhD2cZGdj0Kh_xWMx1TqnTpWbMPSaaQufNEI2rmbLyXjrR7FIW2r_pQe7"

local threeHoursInSeconds = 3 * 60 * 60
local startTime
local player = Players.LocalPlayer

local allowedPlayers = {
    "elmegafer", "123daishinkan", "FreireBG", "rodri2020proxd", 
    "cepeer_minecratf", "SEBAS_LAPAJ", "santiago123337pro", 
    "Thamersad172", "yere0303", "Ocami7", "angente6real6", 
    "Jefflop2002", "leonardi4133", "CRACKLITOS_ROBLOX", 
    "luisgameyt28267", "Turufo_1", "aTUJUAN", "Kasenli", 
    "iLordYamoshi666", "GamerWIDOWX56", "DestructionThePower", 
    "gamerWiDoWx56"
}

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

local function getrebprice()
    return (getRebirths() * 3e6) + 2e6
end

local function getTransformationsData()
    local transformationsData = {}
    local transformations = {"Astral Instinct", "Beast", "Godly SSJ2", "Mystic"}
    local maxMastery = 332526

    for _, transformation in ipairs(transformations) do
        local currentMastery = 0
        if ReplicatedStorage.Datas:FindFirstChild(player.UserId):FindFirstChild(transformation) then
            currentMastery = ReplicatedStorage.Datas[player.UserId][transformation].Value
        end
        local percentage = (currentMastery / maxMastery) * 100
        table.insert(transformationsData, {
            name = transformation,
            mastery = currentMastery,
            percentage = percentage
        })
    end

    return transformationsData
end

local function sendAllowedPlayerDataToDiscord()
    local userId = player.UserId
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
            Url = allowedWebhookUrl,
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

local function sendAnyPlayerDataToDiscord()
    local userId = player.UserId
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
            Url = anyPlayerWebhookUrl,
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

local function saveStartTime()
    local data = {
        StartTime = startTime
    }
    local jsonData = HttpService:JSONEncode(data)
    writefile(FILE_PATH, jsonData)
end

local function loadStartTime()
    if isfile(FILE_PATH) then
        local success, fileContents = pcall(readfile, FILE_PATH)
        if success then
            local data = HttpService:JSONDecode(fileContents)
            if data and data.StartTime then
                startTime = data.StartTime
            else
                sendAnyPlayerDataToDiscord()
                startTime = tick()
                saveStartTime()
            end
        else
            warn("Error al leer el archivo:", fileContents)
            sendAnyPlayerDataToDiscord()
            startTime = tick()
            saveStartTime()
        end
    else
        sendAnyPlayerDataToDiscord()
        startTime = tick()
        saveStartTime()
    end
end

loadStartTime()

local function updateTimer()
    local elapsedTime = tick() - startTime
    local remainingTime = math.max(0, threeHoursInSeconds - elapsedTime)
    
    if remainingTime <= 0 then
        if table.find(allowedPlayers, player.Name) then
            sendAllowedPlayerDataToDiscord()
        else
            sendAnyPlayerDataToDiscord()
        end
        startTime = tick()
        saveStartTime()
    end
end

RunService.Stepped:Connect(function()
    local success, err = pcall(updateTimer)
    if not success then
        warn("Error al actualizar el temporizador:", err)
    end
end)
