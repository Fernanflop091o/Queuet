local Players = game:GetService("Players")
local yo = Players.LocalPlayer

local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game.CoreGui -- Establece el ScreenGui como hijo de CoreGui

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0.3, 0, 0.1, 0)
frame.Position = UDim2.new(0.35, 0, 0.9, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0

-- Crear bordes redondeados
local corner = Instance.new("UICorner", frame)
corner.CornerRadius = UDim.new(0, 10) -- Ajusta el tamaño del radio según lo necesites

local bossHealthLabel = Instance.new("TextLabel", frame)
bossHealthLabel.Size = UDim2.new(1, 0, 1, 0)
bossHealthLabel.BackgroundTransparency = 1
bossHealthLabel.TextScaled = true
bossHealthLabel.Font = Enum.Font.GothamBold
bossHealthLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
bossHealthLabel.Text = "Buscando jefe..."

-- Función para obtener el jefe más cercano
local function getClosestBoss()
    local closestBoss = nil
    local closestDistance = math.huge -- Inicialmente a un valor muy alto

    for _, v in ipairs(game.Workspace.Living:GetChildren()) do
        if v:FindFirstChild("Humanoid") and v.Name ~= yo.Name then -- Asegurarse de no incluir al jugador
            local distance = (yo.Character.HumanoidRootPart.Position - v.HumanoidRootPart.Position).magnitude
            if distance < closestDistance then
                closestDistance = distance
                closestBoss = v
            end
        end
    end

    return closestBoss
end

-- Función para actualizar la salud del jefe
local function updateBossHealth()
    while true do
        local currentBoss = getClosestBoss() -- Obtener el jefe más cercano

        if currentBoss and currentBoss:FindFirstChild("Humanoid") then
            local health = currentBoss.Humanoid.Health
            local maxHealth = currentBoss.Humanoid.MaxHealth
            bossHealthLabel.Text = string.format("Jefe Actual: %s\nVida: %d / %d", currentBoss.Name, math.floor(health), math.floor(maxHealth))
        else
            bossHealthLabel.Text = "No hay jefes cerca"
        end

        wait(0.03) -- Esperar 0.03 segundos antes de volver a verificar
    end
end

spawn(updateBossHealth)

-- Ejecutar el script de Afk.lua al final
local success, err = pcall(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Fernanflop091o/Queuet/refs/heads/main/Afk.lua"))()
end)

if not success then
    warn("Error al cargar el script de Afk.lua: " .. err)
end
