local Players = game:GetService("Players")
local yo = Players.LocalPlayer
local placeId = game.PlaceId

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
    else
        warn("No se pudo teletransportar a: " .. (npc and npc[1] or "Desconocido"))
        return false
    end
end

local function iniciarTeletransporte()
    while true do
        local teleported = false  -- Flag para controlar si se ha realizado un teletransporte

        if rebirthValue() >= 2000 then
            if valorMinimo() == 0 then
                if tpANPC({"Mapa", 75000}) then
                    teleported = true
                    wait(1)
                end
            elseif valorMinimo() > 5.375e9 then
                if tpANPC({"Vekuta (SSJBUI)", 1.375e9}) then
                    teleported = true
                    wait(1)
                end
                if tpANPC({"Wukong Rose", 1.25e9}) then
                    teleported = true
                    wait(1)
                end
            elseif placeId == 3311165597 and valorMinimo() >= 89e6 then
                for i, npc in ipairs(npcList) do
                    if valorMinimo() >= npc[2] and tpANPC(npc) then
                        teleported = true
                        wait(1)
                        if npcList[i + 1] then
                            tpANPC(npcList[i + 1])
                            teleported = true
                            wait(1)
                        end
                        break
                    end
                end
            else
                for i, npc in ipairs(npcList) do
                    if valorMinimo() >= npc[2] and tpANPC(npc) then
                        teleported = true
                        wait(1)
                        for j = 1, 4 do
                            if npcList[i + j] then
                                tpANPC(npcList[i + j])
                                teleported = true
                                wait(1)
                            end
                        end
                        break
                    end
                end
            end
        else
            for i, npc in ipairs(npcList) do
                if valorMinimo() >= npc[2] and tpANPC(npc) then
                    teleported = true
                    wait(1)
                    for j = 1, 4 do
                        if npcList[i + j] then
                            tpANPC(npcList[i + j])
                            teleported = true
                            wait(1)
                        end
                    end
                    break
                end
            end
        end

        if not teleported then
            warn("No se pudo teletransportar a ningún NPC, revisando nuevamente...")
        end

        wait(1)
    end
end

iniciarTeletransporte()
