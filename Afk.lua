local Players = game:GetService("Players")
local yo = Players.LocalPlayer
local placeId = game.PlaceId

-- Lista de NPCs con sus requisitos de fuerza
-- Lista de NPCs con sus requisitos de fuerza
local npcList = {
    {"SSJG Kakata", 37.5e6},            -- Jefe 1
    {"Broccoli", 35.5e6},               -- Jefe 2
    {"SSJB Wukong", 2e6},
    {"Kai-fist Master", 1.625e6},
    {"SSJ2 Wukong", 1.25e6},
    {"Perfect Atom", 875000},
    {"Chilly", 550000},
    {"Super Vegetable", 188000},
    {"Top X Fighter", 115000},
    {"Mapa", 75000},
    {"Radish", 45000},
    {"Kid Nohag", 20000},
    {"Klirin", 0},
    {"Vekuta (SSJBUI)", 1.375e9},       -- Jefe 3
    {"Wukong Rose", 1.25e9},            -- Jefe 4
    {"Vekuta (LBSSJ4)", 1.05e9},
    {"Wukong (LBSSJ4)", 675e6},
    {"Vegetable (LBSSJ4)", 450e6},
    {"Vis (20%)", 250e6},
    {"Vills (50%)", 150e6},
    {"Wukong (Omen)", 75e6},
    {"Vegetable (GoD in-training)", 50e6},
}



-- Lista de jefes con sus requisitos de fuerza
local bosses1 = {
    {"Wukong Rose", 1.25e9},
    {"Vekuta (SSJBUI)", 1.375e9},
}

local bosses2 = {
    {"Broccoli", 35.5e6},       -- Añadido Broccoli
    {"SSJG Kakata", 37.5e6},    -- Añadido SSJG Kakata
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

-- Función para teletransportarse a un NPC
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

-- Función para verificar la vida de los jefes
local function jefeEstaVivo(jefeNombre)
    local jefeInstance = game.Workspace.Living:FindFirstChild(jefeNombre)
    return jefeInstance and jefeInstance:FindFirstChild("Humanoid") and jefeInstance.Humanoid.Health > 0
end

-- Función para teletransportarse entre los jefes de la primera lista
local function tpEntreJefes1()
    while true do
        local jefe1Vivo = jefeEstaVivo(bosses1[1][1])
        local jefe2Vivo = jefeEstaVivo(bosses1[2][1])

        if jefe1Vivo and jefe2Vivo then
            tpANPC(bosses1[1])
            wait(1)
            tpANPC(bosses1[2])
        elseif jefe1Vivo then
            tpANPC(bosses1[1])
        elseif jefe2Vivo then
            tpANPC(bosses1[2])
        else
            print("Ambos jefes de la lista 1 están muertos, esperando a que revivan...")
            wait(5) -- Esperar un poco antes de volver a verificar
        end

        wait(1) -- Esperar antes de verificar nuevamente
    end
end

-- Función para teletransportarse entre los jefes de la segunda lista
local function tpEntreJefes2()
    while true do
        local jefe1Vivo = jefeEstaVivo(bosses2[1][1])
        local jefe2Vivo = jefeEstaVivo(bosses2[2][1])

        if jefe1Vivo and jefe2Vivo then
            tpANPC(bosses2[1])
            wait(1)
            tpANPC(bosses2[2])
        elseif jefe1Vivo then
            tpANPC(bosses2[1])
        elseif jefe2Vivo then
            tpANPC(bosses2[2])
        else
            print("Ambos jefes de la lista 2 están muertos, esperando a que revivan...")
            wait(5) -- Esperar un poco antes de volver a verificar
        end

        wait(1) -- Esperar antes de verificar nuevamente
    end
end

-- Función principal de teletransporte
local function iniciarTeletransporte()
    while true do
        local success, err = pcall(function()
            if rebirthValue() >= 2000 then
                if valorMinimo() == 0 then
                    tpANPC({"Mapa", 75000})
                    wait(1)
                
                elseif valorMinimo() > 73e6 then
                    -- Teletransportarse entre jefes de la lista 1
                    tpEntreJefes1()      
                elseif placeId == 3311165597 and valorMinimo() < 73e6 then
                    -- Teletransportarse a NPCs en la lista
                    local npc1 = {"Broccoli", 35.5e6}
                    local npc2 = {"SSJG Kakata", 37.5e6}
                    local npc3 = {"SSJB Wukong", 2e6}
                    tpANPC(npc1)
                    wait(1)
                    tpANPC(npc2)
                    wait(1)
                    tpANPC(npc3)
                    wait(1)
                else
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
