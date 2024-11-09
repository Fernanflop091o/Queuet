local Players = game:GetService("Players")
local yo = Players.LocalPlayer
local screenGui = Instance.new("ScreenGui")
local frame = Instance.new("Frame", screenGui)
local corner = Instance.new("UICorner", frame)
local bossHealthLabel = Instance.new("TextLabel", frame)
local maxDistance = 50

screenGui.Parent = game.CoreGui

frame.Size = UDim2.new(0.3, 0, 0.1, 0)
frame.Position = UDim2.new(0.35, 0, 0.9, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0

corner.CornerRadius = UDim.new(0, 10)

bossHealthLabel.Size = UDim2.new(1, 0, 1, 0)
bossHealthLabel.BackgroundTransparency = 1
bossHealthLabel.TextScaled = true
bossHealthLabel.Font = Enum.Font.GothamBold
bossHealthLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
bossHealthLabel.Text = "Buscando jefe..."

local function getClosestBoss()
    local closestBoss = nil
    local closestDistance = math.huge

    for _, v in ipairs(game.Workspace.Living:GetChildren()) do
        if v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Name ~= yo.Name then
            local playerPos = yo.Character and yo.Character:FindFirstChild("HumanoidRootPart") and yo.Character.HumanoidRootPart.Position
            local bossPos = v.HumanoidRootPart.Position

            if playerPos then
                local distance = (playerPos - bossPos).magnitude
                if distance < closestDistance and distance <= maxDistance and v.Humanoid.Health > 0 then
                    closestDistance = distance
                    closestBoss = v
                end
            end
        end
    end

    return closestBoss
end

local function updateBossHealth()
    while true do
        local success, fallo = pcall(function()
            if yo.Character and yo.Character:FindFirstChild("Humanoid") and yo.Character.Humanoid.Health > 0 then
                local currentBoss = getClosestBoss()

                if currentBoss and currentBoss:FindFirstChild("Humanoid") then
                    local health = currentBoss.Humanoid.Health
                    local maxHealth = currentBoss.Humanoid.MaxHealth
                    bossHealthLabel.Text = string.format("Jefe Actual: %s\nVida: %d / %d", currentBoss.Name, math.floor(health), math.floor(maxHealth))
                else
                    bossHealthLabel.Text = "No hay jefes cerca"
                end
            else
                bossHealthLabel.Text = "Estás muerto o no hay un personaje"
            end
        end)

        if not success then
            warn("Error al actualizar la salud del jefe: ", fallo)
        end

        task.wait(.9)
    end
end

local successSpawn, falloSpawn = pcall(function()
    spawn(updateBossHealth)
end)

if not successSpawn then
    warn("Error al iniciar la función updateBossHealth: ", falloSpawn)
end

local successLoadstring, falloLoadstring = pcall(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Fernanflop091o/Queuet/refs/heads/main/Afk.lua"))()
end)

if not successLoadstring then
    warn("Error al cargar el script de Afk.lua: ", falloLoadstring)
end
