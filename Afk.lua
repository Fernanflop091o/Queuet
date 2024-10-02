local Players = game:GetService("Players")
local yo = Players.LocalPlayer

-- Lista de NPCs con su fuerza mínima requerida
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
    {"Klirin", 0},
    {"Vekuta (SSJBUI)", 1.375e9},
    {"Wukong Rose", 1.25e9},
    {"Vekuta (LBSSJ4)", 1.05e9},
    {"Wukong (LBSSJ4)", 675e6},
    {"Vegetable (LBSSJ4)", 450e6},
    {"Vis (20%)", 250e6},
    {"Vills (50%)", 150e6},
    {"Wukong (Omen)", 75e6},
    {"Vegetable (GoD in-training)", 50e6},
}

-- Función que verifica si el jugador está activo y puede ser teletransportado
local function player()
    return yo.Character and yo.Character:FindFirstChild("Humanoid") and yo.Character.Humanoid.Health > 0 and yo.Character:FindFirstChild("HumanoidRootPart")
end

-- Retorna el valor de fuerza actual del jugador
local function valorMinimo()
    return game.ReplicatedStorage.Datas[yo.UserId].Strength.Value
end

-- Retorna el valor de rebirth actual del jugador
local function rebirthValue()
    return game.ReplicatedStorage.Datas[yo.UserId].Rebirth.Value
end

-- Función para teletransportar al jugador a un NPC específico
local function tpANPC(npc)
    local npcInstance = game.Workspace.Others.NPCs:FindFirstChild(npc[1])
    if npcInstance and npcInstance:FindFirstChild("HumanoidRootPart") and player() then
        yo.Character.HumanoidRootPart.CFrame = npcInstance.HumanoidRootPart.CFrame * CFrame.new(3, 0, 0)
        return true
    end
    return false
end

-- Función principal para manejar el teletransporte basado en la fuerza
local function iniciarTeletransporte()
    while true do
        if rebirthValue() >= 2000 then
            -- Verifica si la fuerza es mayor a 5.375e9
            if valorMinimo() > 5.375e9 then
                -- Solo teletransporta a los dos NPCs más fuertes
                local npc1 = {"Vekuta (SSJBUI)", 1.375e9}
                local npc2 = {"Wukong Rose", 1.25e9}

                tpANPC(npc1)
                wait(0.5)  -- Espera medio segundo antes de ir al siguiente
                tpANPC(npc2)
            else
                -- Si la fuerza es menor, sigue con el flujo normal de NPCs
                local lastNpcIndex = nil
                for i, npc in ipairs(npcList) do
                    if valorMinimo() >= npc[2] then
                        lastNpcIndex = i

                        if tpANPC(npc) then
                            wait(0.01)

                            if npcList[i + 1] then
                                tpANPC(npcList[i + 1])
                                wait(0.01)

                                if npcList[i + 2] then
                                    tpANPC(npcList[i + 2])
                                    wait(0.01)

                                    if npcList[i + 3] then
                                        tpANPC(npcList[i + 3])
                                        wait(0.01)

                                        if npcList[i + 4] then
                                            tpANPC(npcList[i + 4])
                                        end
                                    end
                                end
                            end
                            break
                        end
                    end
                end
            end
        end
        wait(1) -- Espera un segundo antes de revisar de nuevo
    end
end

-- Inicia la función de teletransporte
iniciarTeletransporte()
