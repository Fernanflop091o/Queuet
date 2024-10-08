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

local function logError(err)
    warn("Error: " .. tostring(err))
end

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
    local success, err = pcall(function()
        local npcInstance = game.Workspace.Others.NPCs:FindFirstChild(npc[1])
        if npcInstance and npcInstance:FindFirstChild("HumanoidRootPart") and player() then
            yo.Character.HumanoidRootPart.CFrame = npcInstance.HumanoidRootPart.CFrame * CFrame.new(3, 0, 0)
        else
            error("NPC or player HumanoidRootPart not found for: " .. npc[1])
        end
    end)

    if not success then
        logError(err)
        return false
    end
    return true
end

local function iniciarTeletransporte()
    while true do
        local success, err = pcall(function()
            if rebirthValue() >= 2000 then
                if valorMinimo() == 0 then
                    local npcMapa = {"Mapa", 75000}
                    tpANPC(npcMapa)
                    wait(1)
                elseif valorMinimo() < 2.875e9 and placeId == 3311165597 then
                    local npc1 = {"Broccoli", 35.5e6}
                    local npc2 = {"SSJG Kakata", 37.5e6}
                    tpANPC(npc1)
                    wait(1)
                    tpANPC(npc2)
                    wait(1)
                elseif valorMinimo() > 2.875e9 then
                    local npc1 = {"Vekuta (SSJBUI)", 1.375e9}
                    local npc2 = {"Wukong Rose", 1.25e9}

                    if tpANPC(npc1) then
                        wait(1)
                    end

                    if tpANPC(npc2) then
                        wait(1)
                    end
                else
                    local lastNpcIndex = nil
                    for i, npc in ipairs(npcList) do
                        if valorMinimo() >= npc[2] then
                            lastNpcIndex = i

                            if tpANPC(npc) then
                                wait(1)

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
                                                wait(1)
                                            end
                                        end
                                    end
                                end
                                break
                            end
                        end
                    end
                end
            else
                local lastNpcIndex = nil
                for i, npc in ipairs(npcList) do
                    if valorMinimo() >= npc[2] then
                        lastNpcIndex = i

                        if tpANPC(npc) then
                            wait(1)

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
                                            wait(1)
                                        end
                                    end
                                end
                            end
                            break
                        end
                    end
                end
            end
        end)

        if not success then
            logError(err)
        end
        wait(1)
    end
end

iniciarTeletransporte()
