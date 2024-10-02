local Players = game:GetService("Players")
local yo = Players.LocalPlayer

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
        yo.Character.HumanoidRootPart.CFrame = npcInstance.HumanoidRootPart.CFrame * CFrame.new(3, 0, 0)
        return true
    end
    return false
end

local function iniciarTeletransporte()
    while true do
        if rebirthValue() >= 2000 then
            if valorMinimo() <= 0 then
                -- Teletransportar al NPC "Mapa" si la fuerza es menor o igual a 0
                local npcMapa = {"Mapa", 75000}
                local successMapa, errMapa = pcall(function()
                    if tpANPC(npcMapa) then
                        wait(0.8)  -- Espera medio segundo después de teletransportar a "Mapa"
                    else
                        error("Error al teletransportar a " .. npcMapa[1])
                    end
                end)

                if not successMapa then
                    warn(errMapa)  -- Muestra un mensaje de advertencia en caso de error
                end
            elseif valorMinimo() > 5.375e9 then
                -- Teletransportar a los dos NPCs más fuertes
                local npc1 = {"Vekuta (SSJBUI)", 1.375e9}
                local npc2 = {"Wukong Rose", 1.25e9}

                local success1, err1 = pcall(function()
                    if tpANPC(npc1) then
                        wait(0.7)  -- Espera medio segundo antes de ir al siguiente
                    else
                        error("Error al teletransportar a " .. npc1[1])
                    end
                end)

                if not success1 then
                    warn(err1)  -- Muestra un mensaje de advertencia en caso de error
                end

                local success2, err2 = pcall(function()
                    if tpANPC(npc2) then
                        wait(0.7)  -- Espera medio segundo después de teletransportar al segundo NPC
                    else
                        error("Error al teletransportar a " .. npc2[1])
                    end
                end)

                if not success2 then
                    warn(err2)  -- Muestra un mensaje de advertencia en caso de error
                end
            else
                local lastNpcIndex = nil
                for i, npc in ipairs(npcList) do
                    if valorMinimo() >= npc[2] then
                        lastNpcIndex = i

                        local success, err = pcall(function()
                            if tpANPC(npc) then
                                wait(0.8)

                                for j = 1, 4 do
                                    if npcList[i + j] then
                                        if tpANPC(npcList[i + j]) then
                                            wait(0.8)
                                        else
                                            error("Error al teletransportar a " .. npcList[i + j][1])
                                        end
                                    end
                                end
                            end
                        end)

                        if not success then
                            warn(err)  -- Muestra un mensaje de advertencia en caso de error
                        end
                        break
                    end
                end
            end
        end
        wait(0.7)
    end
end

iniciarTeletransporte()
