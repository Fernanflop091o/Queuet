local Players = game:GetService("Players")
local yo = Players.LocalPlayer

-- Lista de NPCs y su fuerza mínima requerida
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

local function player()
    return yo.Character and yo.Character:FindFirstChild("Humanoid") and yo.Character.Humanoid.Health > 0 and yo.Character:FindFirstChild("HumanoidRootPart")
end

local function valorMinimo()
    return game.ReplicatedStorage.Datas[yo.UserId].Strength.Value
end

local function rebirthValue()
    return game.ReplicatedStorage.Datas[yo.UserId].Rebirth.Value
end

local function tpANPC(npc)
    local npcInstance = game.Workspace.Others.NPCs:FindFirstChild(npc[1])
    if npcInstance and npcInstance:FindFirstChild("HumanoidRootPart") and player() then
        yo.Character.HumanoidRootPart.CFrame = npcInstance.HumanoidRootPart.CFrame * CFrame.new(3, 0, 0) -- Teletransporta al jugador a 3 unidades al lado del NPC
        print("Teletransportado junto al NPC: " .. npc[1])
        return true
    end
    return false
end

local function iniciarTeletransporte()
    while true do
        if rebirthValue() >= 2000 then
            if valorMinimo() == 0 then
                -- Teletransportar desde Mapa si la fuerza es 0
                local mapaNpc = game.Workspace.Others.NPCs:FindFirstChild("Mapa")
                if mapaNpc and mapaNpc:FindFirstChild("HumanoidRootPart") and player() then
                    yo.Character.HumanoidRootPart.CFrame = mapaNpc.HumanoidRootPart.CFrame * CFrame.new(3, 0, 0) -- Teletransporta al jugador al lado del NPC "Mapa"
                    print("Teletransportado desde Mapa")
                    wait(1) -- Espera un segundo antes de continuar
                end
            else
                -- Teletransportar entre cinco NPCs actuales
                local lastNpcIndex = nil

                for i, npc in ipairs(npcList) do
                    if valorMinimo() >= npc[2] then
                        lastNpcIndex = i  -- Guarda el índice del NPC actual

                        -- Teletransporta al NPC actual
                        if tpANPC(npc) then
                            wait(0.4) -- Espera 0.01 segundos

                            -- Teletransporta al siguiente NPC
                            if npcList[i + 1] then
                                tpANPC(npcList[i + 1]) -- Teletransporta al siguiente NPC
                                print("Teletransportado junto al siguiente NPC: " .. npcList[i + 1][1])
                                wait(0.4) -- Espera 0.01 segundos

                                -- Teletransporta al siguiente del siguiente NPC
                                if npcList[i + 2] then
                                    tpANPC(npcList[i + 2]) -- Teletransporta al siguiente del siguiente NPC
                                    print("Teletransportado junto al siguiente del siguiente NPC: " .. npcList[i + 2][1])
                                    wait(0.4) -- Espera 0.01 segundos

                                    -- Teletransporta al siguiente del siguiente del siguiente NPC
                                    if npcList[i + 3] then
                                        tpANPC(npcList[i + 3]) -- Teletransporta al siguiente del siguiente del siguiente NPC
                                        print("Teletransportado junto al siguiente del siguiente del siguiente NPC: " .. npcList[i + 3][1])
                                        wait(0.4) -- Espera 0.01 segundos

                                        -- Teletransporta al siguiente del siguiente del siguiente del siguiente NPC
                                        if npcList[i + 4] then
                                            tpANPC(npcList[i + 4]) -- Teletransporta al siguiente del siguiente del siguiente del siguiente NPC
                                            print("Teletransportado junto al siguiente del siguiente del siguiente del siguiente NPC: " .. npcList[i + 4][1])
                                        end
                                    end
                                end
                            end
                            break  -- Salimos del bucle para evitar múltiples teletransportes en un solo ciclo
                        end
                    end
                end
            end
        end
        wait(1)  -- Espera un segundo antes de volver a verificar
    end
end

iniciarTeletransporte()
