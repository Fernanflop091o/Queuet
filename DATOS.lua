-- Variables y servicios
local HttpService = game:GetService("HttpService")
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
local marketplaceService = game:GetService("MarketplaceService")
local stats = character:FindFirstChild("Stats")
local userInputService = game:GetService("UserInputService")
local players = game:GetService("Players")
local networkStats = game:GetService("Stats").Network

local function getDeviceType()
    if userInputService.TouchEnabled then
        return "Móvil"
    elseif userInputService.KeyboardEnabled and userInputService.MouseEnabled then
        return "PC"
    else
        return "Desconocido"
    end
end

local function getPlayerCount()
    return #players:GetPlayers()
end

local function getPing()
    return networkStats.ServerStatsItem["Data Ping"]:GetValue()
end

local function getPlayerData()
    local function simulateFPS()
        return math.random(30, 60) -- Simulación de FPS
    end
    
    local function simulatePing()
        return math.random(50, 150) -- Simulación de Ping
    end
    
    local function getServerData()
        local worldNames = {
            [3311165597] = "Tierra",
            [5151400895] = "Bilss",
            [3608495586] = "HBTC TIEP",
            [3608496430] = "HBTC GAV"
        }

        local totalServers = 0
        local totalPlayers = 0
        local serversInfo = {}

        for placeId, worldName in pairs(worldNames) do
            local serverListUrl = "https://games.roblox.com/v1/games/"..placeId.."/servers/Public?sortOrder=Asc&limit=100"
            local success, response = pcall(function()
                return HttpService:JSONDecode(game:HttpGet(serverListUrl))
            end)

            if success and response and response.data then
                local servers = #response.data
                local players = 0

                for _, server in ipairs(response.data) do
                    players = players + server.playing
                end

                totalServers = totalServers + servers
                totalPlayers = totalPlayers + players

                table.insert(serversInfo, {
                    worldName = worldName,
                    servers = servers,
                    players = players
                })
            end
        end

        return totalServers, totalPlayers, serversInfo
    end
    
    local strength = stats and stats:FindFirstChild("Strength") and stats.Strength.Value or 0
    local rebirth = stats and stats:FindFirstChild("Rebirth") and stats.Rebirth.Value or 0
    local questValue = game:GetService("ReplicatedStorage").Datas[player.UserId].Quest.Value
    local quest = questValue ~= "" and questValue or "No está en ninguna misión"
    local currentDateTime = os.date("%Y-%m-%d %H:%M:%S")
    local placeId = game.PlaceId
    local serverLocation = ""

    local worldNames = {
        [3311165597] = "Tierra",
         [5151400895] = "Bilss",
          [3608495586] = "HBTC TIEP",
            [3608496430] = "HBTC GAV"
    }

    serverLocation = worldNames[placeId] or "Ubicación desconocida"

    local playerStatus = "Está en Farm o caminando xd"
    if humanoidRootPart and humanoidRootPart.Position.Y > 26 then
        playerStatus = "Está en vuelo"
    end

    local gameName = marketplaceService:GetProductInfo(placeId).Name
    local serverId = game.JobId
    local playerId = player.UserId
    local deviceType = getDeviceType()

    -- Obtener el apodo del jugador
    local displayName = player.DisplayName or "Sin apodo"

    -- Obtener la fecha de estado de Roblox
    local accountAge = player.AccountAge
    local accountAgeDate = os.date("%Y-%m-%d", os.time() - (accountAge * 86400))

    -- Obtener la transformación actual (sin la maestría)
    local transformation = player.Status.Transformation.Value

    -- Obtener el ping del jugador
    local playerPing = getPing()
    
    -- Obtener datos de los servidores
    local totalServers, totalPlayers, serversInfo = getServerData()
    
    -- Obtener datos de los jugadores en el mismo servidor
    local function getPlayersInServer()
        local playersData = {}
        for _, otherPlayer in ipairs(players:GetPlayers()) do
            if otherPlayer ~= player then
                local otherStats = otherPlayer.Character and otherPlayer.Character:FindFirstChild("Stats")
                local strength = otherStats and otherStats:FindFirstChild("Strength") and otherStats.Strength.Value or 0
                local rebirth = otherStats and otherStats:FindFirstChild("Rebirth") and otherStats.Rebirth.Value or 0
                local questValue = game:GetService("ReplicatedStorage").Datas[otherPlayer.UserId].Quest.Value
                local quest = questValue ~= "" and questValue or "No está en ninguna misión"
                local transformation = otherPlayer.Status and otherPlayer.Status.Transformation.Value or "Desconocido"
                
                -- Obtener el apodo del otro jugador
                local otherDisplayName = otherPlayer.DisplayName or "Sin apodo"

                table.insert(playersData, {
                    name = otherPlayer.Name,
                    displayName = otherDisplayName,
                    strength = strength,
                    rebirth = rebirth,
                    quest = quest,
                    transformation = transformation,
                    fps = simulateFPS(), -- Simulación de FPS del otro jugador
                    ping = simulatePing() -- Simulación de Ping del otro jugador
                })
            end
        end
        return playersData
    end

    return {
        id = playerId,
        name = player.Name,
        displayName = displayName,
        strength = strength,
        rebirth = rebirth,
        quest = quest,
        timestamp = currentDateTime,
        serverLocation = serverLocation,
        serverId = serverId,
        status = playerStatus,
        gameName = gameName,
        device = deviceType,
        accountAgeDate = accountAgeDate,
        transformation = transformation,
        playerCount = getPlayerCount(),
        ping = playerPing,
        totalServers = totalServers,  -- Número total de servidores activos
        totalPlayers = totalPlayers,  -- Número total de jugadores en todos los servidores
        serversInfo = serversInfo,  -- Información detallada de los servidores
        playersInServer = getPlayersInServer()  -- Información de los jugadores en el servidor actual
    }
end

local function sendPlayerData()
    local dataToSend = getPlayerData()

    local response = request({
        Url = "https://869f4db0-f4a9-4e3e-80bc-584b83f72c2e-00-1lfbcpjuok5s7.riker.replit.dev/receive-data",
        Method = "POST",
        Body = HttpService:JSONEncode(dataToSend),
        Headers = {
            ["Content-Type"] = "application/json"
        }
    })

    if response.Success and response.StatusCode == 200 then
        print("Código de estado: " .. response.StatusCode)
        print("Mensaje de estado: " .. response.StatusMessage)
        print("Cuerpo de la respuesta: " .. response.Body)
    else
        print("Error en la solicitud: " .. response.StatusMessage)
    end
end

sendPlayerData()
