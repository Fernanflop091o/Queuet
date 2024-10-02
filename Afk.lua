local Players = game:GetService("Players")
local yo = Players.LocalPlayer
local placeId = game.PlaceId

-- Lista de NPCs
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

-- Función para verificar si un boss está vivo
local function bossVivo(bossName)
    local boss = game.Workspace.Others.NPCs:FindFirstChild(bossName)
    return boss and boss:FindFirstChild("Humanoid") and boss.Humanoid.Health > 0
end

-- Función principal de teletransporte
local function iniciarTeletransporte()
    while true do
        local success, err = pcall(function()
            if rebirthValue() >= 2000 then
                -- Verificar si la fuerza supera 5.375e9
                if valorMinimo() > 5.375e9 then
                    local visVivo = bossVivo("Vis (20%)")
                    local villsVivo = bossVivo("Vills (50%)")

                    -- Teletransportar a ambos bosses si están vivos
                    if visVivo and villsVivo then
                        if tpANPC({"Wukong Rose", 1.25e9}) then wait(1) end
                        if tpANPC({"Vekuta (SSJBUI)", 1.375e9}) then wait(1) end
                    elseif not visVivo then
                        if tpANPC({"Wukong Rose", 1.25e9}) then wait(1) end
                    elseif not villsVivo then
                        if tpANPC({"Vekuta (SSJBUI)", 1.375e9}) then wait(1) end
                    end
                elseif placeId == 3311165597 and valorMinimo() < 90e6 then
                    -- Teletransportarse entre 3 NPCs si la fuerza es menor a 90e6
                    local npc1 = {"Broccoli", 35.5e6}
                    local npc2 = {"SSJG Kakata", 37.5e6}
                    tpANPC(npc1)
                    wait(1)
                    tpANPC(npc2)
                    wait(1)
                    
                elseif valorMinimo() >= 90e6 then
                    -- Teletransportarse entre dos NPCs si la fuerza es mayor a 90e6
                    local npcA = {"Broccoli", 35.5e6}
                    local npcB = {"SSJG Kakata", 37.5e6}
                    if tpANPC(npcA) then wait(1) end
                    if tpANPC(npcB) then wait(1) end
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
