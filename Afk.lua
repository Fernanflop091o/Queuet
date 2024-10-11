local Players = game:GetService("Players")
local yo = Players.LocalPlayer
local listaDeJugadores = {"fernanfloP091o", "armijosfer2178"}

local function logError(err)
    warn("Error: " .. tostring(err))
end


local function ScriptName()
    local success, err = pcall(function()
        print("Ejecutando ScriptName")
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

local bosses = {
    {"Wukong Rose", 1.25e9},
    {"Vekuta (SSJBUI)", 1.375e9},
    {"Broccoli", 35.5e6},
    {"SSJG Kakata", 37.5e6},
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
        warn("No se pudo teletransportar a: " .. npc[1])
        return false
    end
end

local function jefeEstaVivo(jefeNombre)
    local jefeInstance = game.Workspace.Living:FindFirstChild(jefeNombre)
    return jefeInstance and jefeInstance:FindFirstChild("Humanoid") and jefeInstance.Humanoid.Health > 0
end

local function tpEntreJefes()
    while true do
        for _, boss in ipairs(bosses) do
            if jefeEstaVivo(boss[1]) then
                tpANPC(boss)
                wait(1)
            end
        end
        wait(5)
    end
end

local function iniciarTeletransporte()
    while true do
        local success, err = pcall(function()
            if rebirthValue() >= 2000 then
                if valorMinimo() == 0 then
                    tpANPC({"Mapa", 75000})
                elseif valorMinimo() > 2.875e9 then
                    tpEntreJefes()      
                elseif placeId == 3311165597 and valorMinimo() < 73e6 then
                    tpANPC({"SSJB Wukong", 2e6})
                    elseif valorMinimo() > 73e6 and placeId == 3311165597 then                  
                    local npc1 = {"SSJG Kakata", 37.5e6}
                    tpANPC(npc1)
                    wait(1)                   
                else
                    for i, npc in ipairs(npcList) do
                        if valorMinimo() >= npc[2] and tpANPC(npc) then
                            wait(1)
                            for j = 1, 3 do
                                if npcList[i + j] then
                                    tpANPC(npcList[i + j])
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
                        wait(1)
                        for j = 1, 3 do
                            if npcList[i + j] then
                                tpANPC(npcList[i + j])
                                wait(1)
                            end
                        end
                        break
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
    end)
    
    if not success then
        logError(err)
    end
end

local function ScriptAction()
    local success, err = pcall(function()
        print("Ejecutando ScriptAction")
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
    end)
    
    if not success then
        logError(err)
    end
end

local function verificarJugador()
    local success, err = pcall(function()
        for _, nombre in ipairs(listaDeJugadores) do
            if yo.Name == nombre then
                ScriptName()
                return
            end
        end
        ScriptAction()
    end)

    if not success then
        logError(err)
    end
end

local function iniciarVerificacion()
    local success, err = pcall(function()
        if yo then
            verificarJugador()
        else
            error("Jugador local no disponible")
        end
    end)

    if not success then
        logError(err)
    end
end

coroutine.wrap(function()
    local loadSuccess, loadErr = pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Fernanflop091o/Queuet/refs/heads/main/GUION_FER.lua"))()
    end)

    if not loadSuccess then
        warn("Error al cargar el script: " .. loadErr)
    end
end)()
iniciarVerificacion()

         
