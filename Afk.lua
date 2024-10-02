local Players = game:GetService("Players")
local yo = Players.LocalPlayer
local placeId = game.PlaceId  -- ID del lugar actual

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

-- Verifica si el jugador es válido para teleportarse
local function player()
    return yo.Character and yo.Character:FindFirstChild("Humanoid") and yo.Character.Humanoid.Health > 0 and yo.Character:FindFirstChild("HumanoidRootPart")
end

-- Retorna la fuerza del jugador
local function valorMinimo()
    return game.ReplicatedStorage.Datas[yo.UserId].Strength.Value
end

-- Retorna el valor de rebirth del jugador
local function rebirthValue()
    return game.ReplicatedStorage.Datas[yo.UserId].Rebirth.Value
end

-- Teletransporta al jugador a un NPC
local function tpANPC(npc)
    local npcInstance = game.Workspace.Others.NPCs:FindFirstChild(npc[1])
    if npcInstance and npcInstance:FindFirstChild("HumanoidRootPart") and player() then
        yo.Character.HumanoidRootPart.CFrame = npcInstance.HumanoidRootPart.CFrame * CFrame.new(3, 0, 0)
        return true
    end
    return false
end

-- Función para manejar los teletransportes basados en las condiciones
local function iniciarTeletransporte()
    while true do
        -- Si el jugador tiene más de 2000 rebirths
        if rebirthValue() >= 2000 then
            -- Comienza desde "Mapa" si la fuerza es 0
            if valorMinimo() == 0 then
                local npcMapa = {"Mapa", 75000}
                tpANPC(npcMapa)
                wait(1)  -- Espera 1 segundo después de teletransportar a "Mapa"
            elseif valorMinimo() > 5.375e9 then
                -- Teletransporta a los NPCs más fuertes
                local npc1 = {"Vekuta (SSJBUI)", 1.375e9}
                local npc2 = {"Wukong Rose", 1.25e9}

                if tpANPC(npc1) then
                    wait(1)  -- Espera 1 segundo antes de ir al siguiente NPC
                end

                if tpANPC(npc2) then
                    wait(1)  -- Espera 1 segundo después de teletransportar al segundo NPC
                end
            else
                -- Si el jugador está en el lugar con ID 3311165597 y tiene 150e6 de fuerza o más
                if placeId == 3311165597 and valorMinimo() >= 89e6 then
                    -- Busca dos NPCs consecutivos en la lista
                    local lastNpcIndex = nil
                    for i, npc in ipairs(npcList) do
                        if valorMinimo() >= npc[2] then
                            lastNpcIndex = i

                            if tpANPC(npcList[i]) then
                                wait(1)  -- Espera 1 segundo después de teletransportar al primer NPC

                                -- Teletransporta al siguiente NPC de la lista si existe
                                if npcList[i + 1] then
                                    tpANPC(npcList[i + 1])
                                    wait(1)  -- Espera 1 segundo después del segundo teletransporte
                                end
                                break
                            end
                        end
                    end
                else
                    -- Comienza desde la lista normal de NPCs si no está en el lugar específico o no cumple la fuerza
                    local lastNpcIndex = nil
                    for i, npc in ipairs(npcList) do
                        if valorMinimo() >= npc[2] then
                            lastNpcIndex = i

                            if tpANPC(npc) then
                                wait(1)  -- Espera 1 segundo después de teletransportar a este NPC

                                if npcList[i + 1] then
                                    tpANPC(npcList[i + 1])
                                    wait(1)

                                    if npcList[i + 2] then
                                        tpANPC(npcList[i + 2])
                                        wait(1)

                                        if npcList[i + 3] then
                                            tpANPC(npcList[i + 3])
                                            wait(1)

                                            if npcList[i + 4] then
                                                tpANPC(npcList[i + 4])
                                                wait(1)  -- Espera 1 segundo antes de continuar
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
        else
            -- Si el jugador no tiene 2000 rebirths, revisa la fuerza
            local lastNpcIndex = nil
            for i, npc in ipairs(npcList) do
                if valorMinimo() >= npc[2] then
                    lastNpcIndex = i

                    if tpANPC(npc) then
                        wait(1)  -- Espera 1 segundo después de teletransportar a este NPC

                        if npcList[i + 1] then
                            tpANPC(npcList[i + 1])
                            wait(1)

                            if npcList[i + 2] then
                                tpANPC(npcList[i + 2])
                                wait(1)

                                if npcList[i + 3] then
                                    tpANPC(npcList[i + 3])
                                    wait(1)

                                    if npcList[i + 4] then
                                        tpANPC(npcList[i + 4])
                                        wait(1)  -- Espera 1 segundo antes de continuar
                                    end
                                end
                            end
                        end
                        break
                    end
                end
            end
        end
        wait(1)  -- Espera un momento antes de verificar nuevamente
    end
end

-- Inicia la función de teletransporte
iniciarTeletransporte()
