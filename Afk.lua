local player = game.Players.LocalPlayer
local idleTime = 0
local maxIdleTime = 90 -- 1 minuto y 30 segundos en segundos

-- Función que se ejecutará si el jugador está inactivo por más de 1:30 minutos
local function teleportPlayer()
    game.ReplicatedStorage.Package.Events.TP:InvokeServer("Earth") -- Teletransportar a "Earth"
end

-- Función para reiniciar el contador de inactividad
local function resetIdleTime()
    idleTime = 0
end

-- Monitorizar si el jugador está inactivo
player.Idled:Connect(function()
    idleTime = idleTime + 1

    -- Verificar si el jugador ha estado inactivo durante más de 1:30 minutos
    if idleTime >= maxIdleTime then
        teleportPlayer() -- Teletransportar al jugador a "Earth"
        idleTime = 0 -- Reiniciar el contador después del teletransporte
    end
end)

-- Reiniciar el contador de inactividad si el jugador realiza alguna acción
player.CharacterAdded:Connect(function(character)
    character.HumanoidRootPart:GetPropertyChangedSignal("Position"):Connect(resetIdleTime)
end)
