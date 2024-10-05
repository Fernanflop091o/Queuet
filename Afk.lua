local Players = game:GetService("Players")
local yo = Players.LocalPlayer
local placeId = game.PlaceId

-- Lista de NPCs con sus requisitos de fuerza
local npcList = {
    {"SSJG Kakata", 37.5e6},
    {"Broccoli", 35.5e6},
    {"SSJB Wukong", 2e6},
    {"Kai-fist Master", 1625000},
    {"SSJ2 Wukong", 1250000},
    {"Perfect Atom", 875000},
    {"Chilly", 550000},
    {"Super Vegetable", 188000},
    {"Top X Fighter", 115000},
    {"Mapa", 75000},
    {"Radish", 45000},
    {"Kid Nohag", 20000},
    {"Klirin", 0}
}

-- Jefes que requieren verificación de vida
local bossList = {
    {"Wukong Rose", 1.25e9},
    {"Vekuta (SSJBUI)", 1.375e9}
}

local function player()
    return yo.Character and yo.Character:FindFirstChild("Humanoid") and yo.Character.Humanoid.Health > 0 and yo.Character:FindFirstChild("HumanoidRootPart")
end

local function valorMinimo()
    return game.ReplicatedStorage.Datas[yo.UserId].Strength.Value
end

local function rebirthValue()
    return game.ReplicatedStorage.Datas[yo.UserId].Rebirth.Value
end

-- Función para verificar la vida de los jefes
local function jefeEstaVivo(jefeNombre)
    local jefeInstance = game.Workspace.Living:FindFirstChild(jefeNombre)
    return jefeInstance and jefeInstance:FindFirstChild("Humanoid") and jefeInstance.Humanoid.Health > 0
end

-- Función para teletransportarse a un NPC o jefe
local function tpANPC(npc)
    local npcInstance = game.Workspace.Others.NPCs:FindFirstChild(npc[1])
    if npcInstance and npcInstance:FindFirstChild("HumanoidRootPart") and player() then
        yo.Character.HumanoidRootPart.CFrame = npcInstance.HumanoidRootPart.CFrame * CFrame.new(3, 0, 0) -- Ajuste de la posición
        return true
    else
        warn("No se pudo teletransportar a: " .. npc[1])
        return false
    end
end

-- Función para teletransportarse solo si los jefes están vivos
local function tpEntreJefes()
    while true do
        local jefe1 = bossList[1]
        local jefe2 = bossList[2]
        
        local jefe1Vivo = jefeEstaVivo(jefe1[1])
        local jefe2Vivo = jefeEstaVivo(jefe2[1])

        if jefe1Vivo and jefe2Vivo then
            print("Ambos jefes están vivos, alternando teletransporte entre ellos...")
            tpANPC(jefe1)
            wait(1)
            tpANPC(jefe2)
        elseif jefe1Vivo then
            print(jefe1[1] .. " está vivo, teletransportando solo a " .. jefe1[1])
            tpANPC(jefe1)
        elseif jefe2Vivo then
            print(jefe2[1] .. " está vivo, teletransportando solo a " .. jefe2[1])
            tpANPC(jefe2)
        else
            print("Ambos jefes están muertos, esperando a que revivan...")
        end
        wait(1) -- Esperar antes de verificar nuevamente
    end
end

-- Función principal de teletransporte
local function iniciarTeletransporte()
    while true do
        local success, err = pcall(function()
            -- Verificar si el jugador tiene suficientes rebirths
            if rebirthValue() >= 2000 then
                if valorMinimo() > 2.375e9 then
                    -- Teletransportar entre los jefes Wukong Rose y Vekuta (SSJBUI) si están vivos
                    tpEntreJefes()
                else
                    -- Teletransportar a los NPC normales
                    for i, npc in ipairs(npcList) do
                        if valorMinimo() >= npc[2] then
                            if tpANPC(npc) then
                                wait(1)
                                for j = 1, 4 do
                                    if npcList[i + j] then
                                        tpANPC(npcList[i + j])
                                        wait(1)
                                    end
                                end
                                break
                            end
                        end
                    end
                end
            else
                -- Para jugadores sin suficientes rebirths
                for i, npc in ipairs(npcList) do
                    if valorMinimo() >= npc[2] then
                        if tpANPC(npc) then
                            wait(1)
                            for j = 1, 4 do
                                if npcList[i + j] then
                                    tpANPC(npcList[i + j])
                                    wait(1)
                                end
                            end
                            break
                        end
                    end
                end
            end
            wait(1)
        end)

        if not success then
            warn("Error durante el teletransporte: " .. err)
        end
    end
end

iniciarTeletransporte()
