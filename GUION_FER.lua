local MenuPanel = game.CoreGui:FindFirstChild("Fernando")
if MenuPanel then
    return  
end

local success, fail = pcall(function()
    local player = game.Players.LocalPlayer
    local Players = game:GetService("Players")
    local TweenService = game:GetService("TweenService")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local HttpService = game:GetService("HttpService")
    local TeleportService = game:GetService("TeleportService")
    local ScreenGui = Instance.new("ScreenGui")
    local TextLabel = Instance.new("TextLabel")
    local farmLabel = Instance.new("TextLabel")
    local formsLabel = Instance.new("TextLabel")
    local meleeLabel = Instance.new("TextLabel")
    local tpLabel = Instance.new("TextLabel")
    local Reb = Instance.new("TextLabel")
    local destroyLabel = Instance.new("TextLabel")
    local farmButton = Instance.new("TextButton")
    local formsButton = Instance.new("TextButton")
    local playersButton = Instance.new("TextButton")
    local MinimizeButton = Instance.new("TextButton")
    local MainButton = Instance.new("TextButton")
    local billsButton = Instance.new("TextButton")
    local earthButton = Instance.new("TextButton")
    local leftLine = Instance.new("Frame")
    local rightLine = Instance.new("Frame")
    local topLine = Instance.new("Frame")
    local bottomLine = Instance.new("Frame")
    local centerLine = Instance.new("Frame")
    local upperLine = Instance.new("Frame")
    local middleLine = Instance.new("Frame")
    local frontSwitchLine = Instance.new("Frame")
    local MenuPanel = Instance.new("Frame")
    local ButtonCorner = Instance.new("UICorner")
    local Panel = Instance.new("ImageLabel")
    local panelExpanded = false
    local sound = Instance.new("Sound", game.Workspace)
    local imageLabel = Instance.new("ImageLabel")
    local billsImageLabel = Instance.new("ImageLabel")
    local earthImageLabel = Instance.new("ImageLabel")
    local hbtcButton = Instance.new("TextButton")
    local hbtcImageLabel = Instance.new("ImageLabel")
    local hbtgvButton = Instance.new("TextButton")
    local hbtgvImageLabel = Instance.new("ImageLabel")
    local mle_extLabel = Instance.new("TextLabel")
    local Stats = game:GetService("Stats")
    local RunService = game:GetService("RunService")
    local pingTextLabel = Instance.new("TextLabel")
    local fpsTextLabel = Instance.new("TextLabel")
    local missionTextLabel = Instance.new("TextLabel")
    local timeTextLabel = Instance.new("TextLabel")
    local button = Instance.new("TextButton", screenGui)
    local bestId
   
    
local userId = player.UserId
local thumbnailType = Enum.ThumbnailType.HeadShot
local thumbnailSize = Enum.ThumbnailSize.Size48x48
local thumbnailUrl = Players:GetUserThumbnailAsync(userId, thumbnailType, thumbnailSize)

local UICorner = Instance.new("UICorner")

-- ConfiguraciÃ³n de GUI
ScreenGui.Name = "Fernando"
ScreenGui.Parent = player.PlayerGui
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

TextLabel.Parent = ScreenGui
TextLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
TextLabel.BorderSizePixel = 0
TextLabel.Position = UDim2.new(0.5, -350, 0.4, -130)
TextLabel.Size = UDim2.new(0, 410, 0, 30)
TextLabel.Font = Enum.Font.SourceSans
TextLabel.Text = "Creado הPvtin                                                      "
TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.TextScaled = true
TextLabel.TextStrokeColor3 = Color3.fromRGB(255, 0, 0)
TextLabel.TextStrokeTransparency = 0
TextLabel.Active = true
TextLabel.Draggable = true

MenuPanel.Parent = TextLabel
MenuPanel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MenuPanel.BorderSizePixel = 0
MenuPanel.Position = UDim2.new(0, 0, 1, 0)
MenuPanel.Size = UDim2.new(0, 410, 0, 400)
MenuPanel.Visible = false

MinimizeButton.Parent = TextLabel
MinimizeButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MinimizeButton.BorderSizePixel = 0
MinimizeButton.Position = UDim2.new(0.9, 10, 0.5, -14)
MinimizeButton.Size = UDim2.new(0, 30, 0, 26)
MinimizeButton.Font = Enum.Font.SourceSans
MinimizeButton.Text = "X"
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.TextSize = 18


farmButton.Parent = MenuPanel
farmButton.Size = UDim2.new(1/3, -10, 0, 30)
farmButton.Position = UDim2.new(0, 5, 0, 5)
farmButton.Text = "List_Play"
farmButton.Font = Enum.Font.SourceSans
farmButton.TextSize = 18
farmButton.TextColor3 = Color3.fromRGB(0, 0, 0)
farmButton.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
farmButton.TextStrokeTransparency = 0
farmButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
farmButton.BorderSizePixel = 1
farmButton.BorderColor3 = Color3.fromRGB(255, 255, 255)
farmButton.TextScaled = true



formsButton.Name = "FormsButton"
formsButton.Parent = MenuPanel
formsButton.Size = UDim2.new(1/3, -10, 0, 30)
formsButton.Position = UDim2.new(1/3, 5, 0, 5)
formsButton.Text = "Auto_Kill"
formsButton.Font = Enum.Font.SourceSans
formsButton.TextSize = 18
formsButton.TextColor3 = Color3.fromRGB(0, 0, 0)
formsButton.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
formsButton.TextStrokeTransparency = 0
formsButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
formsButton.BorderSizePixel = 1
formsButton.BorderColor3 = Color3.fromRGB(255, 255, 255)
formsButton.TextScaled = true





playersButton.Parent = MenuPanel
playersButton.Size = UDim2.new(1/3, -10, 0, 30)
playersButton.Position = UDim2.new(2/3, 5, 0, 5)
playersButton.Text = "Players"
playersButton.Font = Enum.Font.SourceSans
playersButton.TextSize = 18
playersButton.TextColor3 = Color3.fromRGB(0, 0, 0)
playersButton.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
playersButton.TextStrokeTransparency = 0
playersButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
playersButton.BorderSizePixel = 1
playersButton.BorderColor3 = Color3.fromRGB(255, 255, 255)
playersButton.TextScaled = true

leftLine.Parent = MenuPanel
leftLine.Size = UDim2.new(0, 3.3, 1, 0)
leftLine.Position = UDim2.new(0, 0, 0, 0)
leftLine.BackgroundColor3 = Color3.fromRGB(0, 0, 255)
leftLine.BorderSizePixel = 0.6

rightLine.Parent = MenuPanel
rightLine.Size = UDim2.new(0, 3.3, 1, 0)
rightLine.Position = UDim2.new(1, -2, 0, 0)
rightLine.BackgroundColor3 = Color3.fromRGB(0, 0, 255)
rightLine.BorderSizePixel = 0.6

topLine.Parent = MenuPanel
topLine.Size = UDim2.new(1, 0, 0, 3)
topLine.Position = UDim2.new(0, 0, 0, 0)
topLine.BackgroundColor3 = Color3.fromRGB(0, 0, 255)
topLine.BorderSizePixel = 0.6

bottomLine.Parent = MenuPanel
bottomLine.Size = UDim2.new(1, 0, 0, 3)
bottomLine.Position = UDim2.new(0, 0, 1, -2)
bottomLine.BackgroundColor3 = Color3.fromRGB(0, 0, 255)
bottomLine.BorderSizePixel = 0.6

centerLine.Parent = MenuPanel
centerLine.Size = UDim2.new(1, 0, 0, 3)
centerLine.Position = UDim2.new(0.5, -205, 0, 60)
centerLine.BackgroundColor3 = Color3.fromRGB(0, 0, 255)
centerLine.BorderSizePixel = 0

upperLine.Parent = MenuPanel
upperLine.Size = UDim2.new(1, 0, 0, 3)
upperLine.Position = UDim2.new(0.5, -205, 0, 105)
upperLine.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
upperLine.BorderSizePixel = 0

middleLine.Parent = MenuPanel
middleLine.Size = UDim2.new(0, 3, 1, -110)
middleLine.Position = UDim2.new(0.5, -1.5, 0, 108)
middleLine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
middleLine.BorderSizePixel = 0

frontSwitchLine.Parent = MenuPanel
frontSwitchLine.Size = UDim2.new(0, 3, 0, 43)
frontSwitchLine.Position = UDim2.new(0.4, 40, 0, 63)
frontSwitchLine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
frontSwitchLine.BorderSizePixel = 0


farmLabel.Parent = MenuPanel
farmLabel.BackgroundTransparency = 1
farmLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
farmLabel.BorderSizePixel = 0
farmLabel.Position = UDim2.new(0.1, -30, 0, 53)
farmLabel.Size = UDim2.new(0, 89, 0, 60)
farmLabel.Font = Enum.Font.SourceSans
farmLabel.Text = "Mission"
farmLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
farmLabel.TextScaled = true
farmLabel.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
farmLabel.TextStrokeTransparency = 0


formsLabel.Parent = MenuPanel
formsLabel.BackgroundTransparency = 1
formsLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
formsLabel.BorderSizePixel = 0
formsLabel.Position = UDim2.new(0.6, -30, 0, 53)
formsLabel.Size = UDim2.new(0, 89, 0, 60)
formsLabel.Font = Enum.Font.SourceSans
formsLabel.Text = "Forms"
formsLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
formsLabel.TextScaled = true
formsLabel.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
formsLabel.TextStrokeTransparency = 0


meleeLabel.Parent = MenuPanel
meleeLabel.BackgroundTransparency = 1
meleeLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
meleeLabel.BorderSizePixel = 0
meleeLabel.Position = UDim2.new(0.01, 5, 0.2,22)
meleeLabel.Size = UDim2.new(0, 89, 0, 60)
meleeLabel.Font = Enum.Font.SourceSans
meleeLabel.Text = "Mele"
meleeLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
meleeLabel.TextScaled = true
meleeLabel.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
meleeLabel.TextStrokeTransparency = 0


tpLabel.Parent = MenuPanel
tpLabel.BackgroundTransparency = 1
tpLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
tpLabel.BorderSizePixel = 0
tpLabel.Position = UDim2.new(0.392, 30, 0.2,22)
tpLabel.Size = UDim2.new(0, 89, 0, 60)
tpLabel.Font = Enum.Font.SourceSans
tpLabel.Text = "Tp"
tpLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
tpLabel.TextScaled = true
tpLabel.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
tpLabel.TextStrokeTransparency = 0

Reb.Parent = MenuPanel
Reb.BackgroundTransparency = 1
Reb.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Reb.BorderSizePixel = 0
Reb.Position = UDim2.new(0.01, 5, 0.3,24)
Reb.Size = UDim2.new(0, 89, 0, 60)
Reb.Font = Enum.Font.SourceSans
Reb.Text = "Reb-Stats"
Reb.TextColor3 = Color3.fromRGB(0, 0, 0)
Reb.TextScaled = true
Reb.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
Reb.TextStrokeTransparency = 0


destroyLabel.Parent = MenuPanel
destroyLabel.BackgroundTransparency = 1
destroyLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
destroyLabel.BorderSizePixel = 0
destroyLabel.Position = UDim2.new(0.01, 5, 0.3,66)
destroyLabel.Size = UDim2.new(0, 99, 0, 60)
destroyLabel.Font = Enum.Font.SourceSans
destroyLabel.Text = "Destroy"
destroyLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
destroyLabel.TextScaled = true
destroyLabel.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
destroyLabel.TextStrokeTransparency = 0


mle_extLabel.Parent = MenuPanel
mle_extLabel.BackgroundTransparency = 1
mle_extLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
mle_extLabel.BorderSizePixel = 0
mle_extLabel.Position = UDim2.new(0.4, 69, 0.4, 35)
mle_extLabel.Size = UDim2.new(0, 39, 0, 40)
mle_extLabel.Font = Enum.Font.SourceSans
mle_extLabel.Text = "MLE_EXT"
mle_extLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
mle_extLabel.TextScaled = true
mle_extLabel.TextStrokeColor3 = Color3.fromRGB(205, 255, 255)
mle_extLabel.TextStrokeTransparency = 0

Panel.Parent = ScreenGui
Panel.BackgroundTransparency = 1
Panel.Position = UDim2.new(0.1, 39, 0, 60)
Panel.Size = UDim2.new(0, 70, 0, 0)
Panel.SizeConstraint = Enum.SizeConstraint.RelativeYY 
Panel.ImageColor3 = Color3.fromRGB(255, 255, 255)
Panel.ScaleType = Enum.ScaleType.Fit 
Panel.SliceCenter = Rect.new(10, 10, 10, 10)


imageLabel.Parent = MenuPanel
imageLabel.Size = UDim2.new(0, 48, 0, 48) 
imageLabel.Position = UDim2.new(1, -58, 0.8, 30) 
imageLabel.BackgroundTransparency = 1 
imageLabel.Image = thumbnailUrl





UICorner.CornerRadius = UDim.new(0, 5.5)
billsButton.Size = UDim2.new(0, 31, 0, 31)
billsButton.Position = UDim2.new(0.55275332428457, 39, 0.4, 7)
billsButton.BackgroundColor3 = Color3.new(0, 0, 0)
billsButton.BackgroundTransparency = 0.5
billsButton.Text = ""  
billsButton.Name = "Bills"  
billsButton.Parent = MenuPanel
UICorner:Clone().Parent = billsButton


billsImageLabel.Size = UDim2.new(1, 0, 1, 0)
billsImageLabel.Position = UDim2.new(0, 0, 0, 0)
billsImageLabel.BackgroundTransparency = 1
billsImageLabel.Image = "rbxassetid://17345700746"
billsImageLabel.Name = "BillsImage"  -- Nombre de la etiqueta de imagen
billsImageLabel.Parent = billsButton


earthButton.Size = UDim2.new(0, 31, 0, 31)
earthButton.Position = UDim2.new(0.47875332428457, 20, 0.4, 7)
earthButton.BackgroundColor3 = Color3.new(0, 0, 0)
earthButton.BackgroundTransparency = 0.5
earthButton.Text = ""  -- Sin texto
earthButton.Name = "Earth"  
earthButton.Parent = MenuPanel
UICorner:Clone().Parent = earthButton

earthImageLabel.Size = UDim2.new(1, 0, 1, 0)
earthImageLabel.Position = UDim2.new(0, 0, 0, 0)
earthImageLabel.BackgroundTransparency = 1
earthImageLabel.Image = "rbxassetid://105319560378349"
earthImageLabel.Name = "EarthImage"  
earthImageLabel.Parent = earthButton  

hbtcButton.Size = UDim2.new(0, 31, 0, 31)
hbtcButton.Position = UDim2.new(0.68875332428457, 39, 0.4, 7)
hbtcButton.BackgroundColor3 = Color3.new(0, 0, 0)  
hbtcButton.BackgroundTransparency = 0.5  
hbtcButton.Text = ""  -- Sin texto
hbtcButton.Name = "HBTC"  
hbtcButton.Parent = MenuPanel  
UICorner:Clone().Parent = hbtcButton  

hbtcImageLabel.Size = UDim2.new(1, 0, 1, 0)
hbtcImageLabel.Position = UDim2.new(0, 0, 0, 0)
hbtcImageLabel.BackgroundTransparency = 1 
hbtcImageLabel.Image = "rbxassetid://126015597245029"  
hbtcImageLabel.Name = "HBTC"  
hbtcImageLabel.Parent = hbtcButton  



hbtgvButton.Size = UDim2.new(0, 31, 0, 31)
hbtgvButton.Position = UDim2.new(0.85875332428457, 20, 0.4, 7)  
hbtgvButton.BackgroundColor3 = Color3.new(0, 0, 0)  
hbtgvButton.BackgroundTransparency = 0.5  
hbtgvButton.Text = ""  -- Sin texto
hbtgvButton.Name = "HBTGV"  
hbtgvButton.Parent = MenuPanel  
UICorner:Clone().Parent = hbtgvButton  

hbtgvImageLabel.Size = UDim2.new(1, 0, 1, 0)
hbtgvImageLabel.Position = UDim2.new(0, 0, 0, 0)
hbtgvImageLabel.BackgroundTransparency = 1  
hbtgvImageLabel.Image = "rbxassetid://129453529806060" 
hbtgvImageLabel.Name = "HBTGVImage"  
hbtgvImageLabel.Parent = hbtgvButton  


pingTextLabel.Name = "PingTextLabel"
pingTextLabel.Position = UDim2.new(0, 32, 0.1, 14)
pingTextLabel.AnchorPoint = Vector2.new(0.5, 0)
pingTextLabel.BackgroundTransparency = 1
pingTextLabel.Font = Enum.Font.SourceSans
pingTextLabel.TextSize = 13
pingTextLabel.TextColor3 = Color3.fromRGB(144, 238, 104)
pingTextLabel.TextStrokeTransparency = 0
pingTextLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
pingTextLabel.Text = "Ping:"
pingTextLabel.Parent = MenuPanel

fpsTextLabel.Name = "FPSTextLabel"
fpsTextLabel.Position = UDim2.new(0, 20, 0.1, 3)
fpsTextLabel.AnchorPoint = Vector2.new(0.5, 0)
fpsTextLabel.BackgroundTransparency = 1
fpsTextLabel.Font = Enum.Font.SourceSans
fpsTextLabel.TextSize = 13
fpsTextLabel.TextColor3 = Color3.fromRGB(0, 0, 255)
fpsTextLabel.TextStrokeTransparency = 0
fpsTextLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
fpsTextLabel.Text = "Fps:"
fpsTextLabel.Parent = MenuPanel


missionTextLabel.Name = "MissionTextLabel"
missionTextLabel.Size = UDim2.new(0, 200, 0, 30)
missionTextLabel.Position = UDim2.new(0.5, 60, 0, 0)
missionTextLabel.AnchorPoint = Vector2.new(0.5, 0)
missionTextLabel.BackgroundTransparency = 1
missionTextLabel.Font = Enum.Font.SourceSans
missionTextLabel.TextSize = 15
missionTextLabel.TextColor3 = Color3.fromRGB(128, 128, 128)
missionTextLabel.TextStrokeTransparency = 0
missionTextLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 255)
missionTextLabel.Text = "Misión: Cargando... | Forma: Cargando..."
missionTextLabel.Parent = TextLabel


timeTextLabel.Name = "TimeTextLabel"
timeTextLabel.Position = UDim2.new(0, 70, 0.1, 3)
timeTextLabel.AnchorPoint = Vector2.new(0.5, 0)
timeTextLabel.BackgroundTransparency = 1
timeTextLabel.Font = Enum.Font.SourceSans
timeTextLabel.TextSize = 13
timeTextLabel.TextColor3 = Color3.fromRGB(128, 128, 128)
timeTextLabel.TextStrokeTransparency = 0
timeTextLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 255)
timeTextLabel.Text = "Hora actual: Cargando..."
timeTextLabel.Parent = MenuPanel


button.Position = UDim2.new(0, 83, 0.1, 14)
button.AnchorPoint = Vector2.new(0.5, 0.5)
button.Size = UDim2.new(0, 26, 0, 9)
button.BackgroundTransparency = 1
button.TextSize = 9.30
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.TextStrokeTransparency = 0
button.TextStrokeColor3 = Color3.fromRGB(0, 0, 255)
button.Text = "Cargando..."
button.Parent = MenuPanel
    
 




local function SafeCall(func, ...)
    local success, result = pcall(func, ...)
    if not success then
        warn("Error capturado: ", result)
    end
    return success, result
end
    


local TweenService = game:GetService("TweenService")
local colorArray = {
    Color3.fromRGB(255, 255, 0),
    Color3.fromRGB(255, 0, 0),
    Color3.fromRGB(255, 165, 0),
    Color3.fromRGB(0, 0, 255),
    Color3.fromRGB(255, 0, 255),
    Color3.fromRGB(144, 238, 144),
    Color3.fromRGB(255, 105, 180),
    Color3.fromRGB(75, 0, 130),
    Color3.fromRGB(72, 209, 204),
    Color3.fromRGB(255, 69, 0)
}

local colorChangeTweenInfo = TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
local blurEffect = Instance.new("BlurEffect")
blurEffect.Size = 5
blurEffect.Parent = game.Lighting

-- Capturar errores en el cambio de color
task.spawn(function()
    local success, err = pcall(function()
        local currentIndex = 1
        while true do
            local nextColor = Color3.new(
                colorArray[currentIndex].R,
                colorArray[currentIndex].G,
                colorArray[currentIndex].B
            )

            local leftLineTween = TweenService:Create(leftLine, colorChangeTweenInfo, {BackgroundColor3 = nextColor, Transparency = 0.6})
            local rightLineTween = TweenService:Create(rightLine, colorChangeTweenInfo, {BackgroundColor3 = nextColor, Transparency = 0.6})
            local topLineTween = TweenService:Create(topLine, colorChangeTweenInfo, {BackgroundColor3 = nextColor, Transparency = 0.6})
            local bottomLineTween = TweenService:Create(bottomLine, colorChangeTweenInfo, {BackgroundColor3 = nextColor, Transparency = 0.6})
            local centerLineTween = TweenService:Create(centerLine, colorChangeTweenInfo, {BackgroundColor3 = nextColor, Transparency = 0.6})
            local upperLineTween = TweenService:Create(upperLine, colorChangeTweenInfo, {BackgroundColor3 = nextColor, Transparency = 0.6})
            local middleLineTween = TweenService:Create(middleLine, colorChangeTweenInfo, {BackgroundColor3 = nextColor, Transparency = 0.6})
            local frontSwitchLineTween = TweenService:Create(frontSwitchLine, colorChangeTweenInfo, {BackgroundColor3 = nextColor, Transparency = 0.6})
            leftLineTween:Play()
            rightLineTween:Play()
            topLineTween:Play()
            bottomLineTween:Play()
            centerLineTween:Play()
            upperLineTween:Play()
            middleLineTween:Play()
            frontSwitchLineTween:Play()
            wait(0.7)
            currentIndex = currentIndex % #colorArray + 1
        end
    end)

    if not success then
        warn("Error en el cambio de color: " .. err)
    end
end)

ButtonCorner.Parent = MinimizeButton
ButtonCorner.CornerRadius = UDim.new(0.5, 0)
sound.SoundId = "rbxassetid://1293432192"

local menuExpanded = false
local expandTweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
local contractTweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.In)
local expandSize = UDim2.new(0, 410, 0, 400)
local contractSize = UDim2.new(0, 410, 0, 0)

local expandTween = TweenService:Create(MenuPanel, expandTweenInfo, {Size = expandSize})
local contractTween = TweenService:Create(MenuPanel, contractTweenInfo, {Size = contractSize})

-- Capturar errores en el click del botón minimizar
MinimizeButton.MouseButton1Click:Connect(function()
    local success, err = pcall(function()
        if menuExpanded then
            contractTween:Play()
            MinimizeButton.Text = "X"
            sound:Play()
            wait(0.5)
            MenuPanel.Visible = false
        else
            MenuPanel.Visible = true
            expandTween:Play()
            MinimizeButton.Text = "X"
            sound:Play()
        end
        menuExpanded = not menuExpanded
    end)

    if not success then
        warn("Error al minimizar/expandir el menú: " .. err)
    end
end)
    

local function updatePing()
    local success, err = pcall(function()
        local ping = Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
        ping = math.floor(ping)
        pingTextLabel.Text = "Ping: " .. ping .. " ms"
    end)

    if not success then
        warn("Error al actualizar el ping: " .. err)
    end
end

local function updateMissionName()
    local success, err = pcall(function()
        missionTextLabel.Text = "Misión: " .. ReplicatedStorage.Datas[player.UserId].Quest.Value .. " | Forma: " .. player.Status.Transformation.Value
    end)

    if not success then
        warn("Error al actualizar el nombre de la misión: " .. err)
    end
end

updateMissionName()
ReplicatedStorage.Datas[Players.LocalPlayer.UserId].Quest:GetPropertyChangedSignal("Value"):Connect(function()
updateMissionName()
SafeCall(Players.LocalPlayer.Status.Transformation:GetPropertyChangedSignal("Value"):Connect(updateText))
end)


local function updateTime()
    local success, err = pcall(function()
        local currentTime = os.date("%H:%M:%S")
        timeTextLabel.Text = "Hora:" .. currentTime
    end)

    if not success then
        warn("Error al actualizar la hora: " .. err)
    end
end

local function initSwitches(MenuPanel)
local function createSwitchModel(parent, position, switchName)
    local switchButton = Instance.new("TextButton")
    switchButton.Parent = parent
    switchButton.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    switchButton.BorderSizePixel = 0
    switchButton.Position = position
    switchButton.Size = UDim2.new(0, 84, 0, 30)
    switchButton.Text = ""

    local switchButtonCorner = Instance.new("UICorner")
    switchButtonCorner.Parent = switchButton
    switchButtonCorner.CornerRadius = UDim.new(0.4, 0)

    local switchBall = Instance.new("Frame")
    switchBall.Parent = switchButton
    switchBall.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    switchBall.Size = UDim2.new(0, 30, 0, 30)
    switchBall.Position = UDim2.new(0, 5, 0.5, -15)
    switchBall.BorderSizePixel = 0

    local switchBallCorner = Instance.new("UICorner")
    switchBallCorner.Parent = switchBall
    switchBallCorner.CornerRadius = UDim.new(0.5, 0)

    return switchButton, switchBall
end

local switchButton1, switchBall1 = createSwitchModel(MenuPanel, UDim2.new(0.1, 75, 0, 69), "Switch1")
local switchButton2, switchBall2 = createSwitchModel(MenuPanel, UDim2.new(0.6, 75, 0, 69), "Switch2")
local switchButton3, switchBall3 = createSwitchModel(MenuPanel, UDim2.new(0.285, 0, 0.2, 36), "Switch3")
local switchButton4, switchBall4 = createSwitchModel(MenuPanel, UDim2.new(0.590, 62, 0.1, 77), "Switch4")
local switchButton5, switchBall5 = createSwitchModel(MenuPanel, UDim2.new(0.220, 19, 0.2, 81), "Switch5")
local switchButton6, switchBall6 = createSwitchModel(MenuPanel, UDim2.new(0.239, 19, 0.2, 125), "Switch6")
local switchButton7, switchBall7 = createSwitchModel(MenuPanel, UDim2.new(0.4, 49, 0.242, 125), "Switch7")

local function SaveSwitchState(isActive, switchName)
    local SwitchInfo = {
        SwitchOn = isActive,
        LastModified = os.time()
    }
    writefile(switchName.."_SwitchState.json", game:GetService("HttpService"):JSONEncode(SwitchInfo))
end

local function LoadSwitchState(switchName)
    if isfile(switchName.."_SwitchState.json") then
        local fileContents = readfile(switchName.."_SwitchState.json")
        if fileContents then
            local switchData = game:GetService("HttpService"):JSONDecode(fileContents)
            if switchData and switchData.SwitchOn ~= nil then
                return switchData.SwitchOn
            end
        end
    end
    return false
end

local function toggleSwitch(isActive, switchBall)
    if isActive then
        switchBall.Position = UDim2.new(1, -35, 0.5, -15)
        switchBall.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    else
        switchBall.Position = UDim2.new(0, 5, 0.5, -15)
        switchBall.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    end
end

local isLoop1Active = LoadSwitchState("Switch1")
local isLoop2Active = LoadSwitchState("Switch2")
local isLoop3Active = LoadSwitchState("Switch3")
local isLoop4Active = LoadSwitchState("Switch4")
local isLoop5Active = LoadSwitchState("Switch5")
local isLoop6Active = LoadSwitchState("Switch6")
local isLoop7Active = LoadSwitchState("Switch7")


local function loop1()
    while true do
        SafeCall(function()
            if isLoop1Active then
                -- Lógica de loop 1
            end
        end)
        wait()
    end
end

local function loop2()
    while true do
        SafeCall(function()
            if isLoop2Active then
                -- Lógica de loop 2
            end
        end)
        wait()
    end
end

local function loop3()
    while true do
        SafeCall(function()
            if isLoop3Active then
                -- Lógica de loop 3
            end
        end)
        wait()
    end
end

local function loop4()
    SafeCall(function()
        -- Lógica de loop 4
        wait()
    end)
end

local function loop5()
    while true do
        SafeCall(function()
            if isLoop5Active then
                -- Lógica de loop 5
            end
        end)
        wait()
    end
end

local function loop6()
    while true do
        SafeCall(function()
            if isLoop6Active then
                -- Lógica de loop 6
            end
        end)
        wait()
    end
end

local function loop7()
    while true do
        SafeCall(function()
            if isLoop7Active then
                -- Lógica de loop 7
            end
        end)
        wait()
    end
end


local function SafeCall(func, ...)
    local success, result = pcall(func, ...)
    if not success then
        warn("Error capturado: ", result)
    end
    return success, result
end

switchButton1.MouseButton1Click:Connect(function()
    SafeCall(function()
        isLoop1Active = not isLoop1Active
        toggleSwitch(isLoop1Active, switchBall1)
        SaveSwitchState(isLoop1Active, "Switch1")
    end)
end)

switchButton2.MouseButton1Click:Connect(function()
    SafeCall(function()
        isLoop2Active = not isLoop2Active
        toggleSwitch(isLoop2Active, switchBall2)
        SaveSwitchState(isLoop2Active, "Switch2")
    end)
end)

switchButton3.MouseButton1Click:Connect(function()
    SafeCall(function()
        isLoop3Active = not isLoop3Active
        toggleSwitch(isLoop3Active, switchBall3)
        SaveSwitchState(isLoop3Active, "Switch3")
    end)
end)

switchButton4.MouseButton1Click:Connect(function()
    SafeCall(function()
        isLoop4Active = not isLoop4Active
        toggleSwitch(isLoop4Active, switchBall4)
        SaveSwitchState(isLoop4Active, "Switch4")
    end)
end)

switchButton5.MouseButton1Click:Connect(function()
    SafeCall(function()
        isLoop5Active = not isLoop5Active
        toggleSwitch(isLoop5Active, switchBall5)
        SaveSwitchState(isLoop5Active, "Switch5")
    end)
end)

switchButton6.MouseButton1Click:Connect(function()
    SafeCall(function()
        isLoop6Active = not isLoop6Active
        toggleSwitch(isLoop6Active, switchBall6)
        SaveSwitchState(isLoop6Active, "Switch6")
    end)
end)

switchButton7.MouseButton1Click:Connect(function()
    SafeCall(function()
        isLoop7Active = not isLoop7Active
        toggleSwitch(isLoop7Active, switchBall7)
        SaveSwitchState(isLoop7Active, "Switch7")
    end)
end)

SafeCall(function() toggleSwitch(isLoop1Active, switchBall1) end)
SafeCall(function() toggleSwitch(isLoop2Active, switchBall2) end)
SafeCall(function() toggleSwitch(isLoop3Active, switchBall3) end)
SafeCall(function() toggleSwitch(isLoop4Active, switchBall4) end)
SafeCall(function() toggleSwitch(isLoop5Active, switchBall5) end)
SafeCall(function() toggleSwitch(isLoop6Active, switchBall6) end)
SafeCall(function() toggleSwitch(isLoop7Active, switchBall7) end)

SafeCall(function() coroutine.wrap(loop1)() end)
SafeCall(function() coroutine.wrap(loop2)() end)
SafeCall(function() coroutine.wrap(loop3)() end)
SafeCall(function() coroutine.wrap(loop4)() end)
SafeCall(function() coroutine.wrap(loop5)() end)
SafeCall(function() coroutine.wrap(loop6)() end)
SafeCall(function() coroutine.wrap(loop7)() end)
end

initSwitches(MenuPanel)

MainButton.MouseButton1Click:Connect(function()
    SafeCall(togglePanel)
end)

earthButton.MouseButton1Click:Connect(function()
    SafeCall(function()
        local playerCount = #game.Players:GetPlayers()
        print("Número de jugadores: " .. playerCount)  -- Para depuración
        if playerCount > 2 then
            game:GetService("TeleportService"):Teleport(3311165597, game.Players.LocalPlayer)
        elseif playerCount < 2 then
            game.ReplicatedStorage.Package.Events.TP:InvokeServer("Earth")
        end
    end)
end)

billsButton.MouseButton1Click:Connect(function()
  SafeCall(function()
        local playerCount = #game.Players:GetPlayers()
        print("Número de jugadores: " .. playerCount)  -- Para depuración
        if playerCount > 2 then
            game:GetService("TeleportService"):Teleport(5151400895, game.Players.LocalPlayer)
        elseif playerCount < 2 then
            game.ReplicatedStorage.Package.Events.TP:InvokeServer("Vills Planet")
        end
    end)
end)

hbtcButton.MouseButton1Click:Connect(function()
    SafeCall(function()
        pcall(function() game:GetService("TeleportService"):Teleport(3608495586) end)
    end)
end)

hbtgvButton.MouseButton1Click:Connect(function()
    SafeCall(function()
      pcall(function() game:GetService("TeleportService"):Teleport(3608496430) end)
    end)
end)

farmButton.MouseButton1Click:Connect(function()
    SafeCall(onFarmButtonClick)
end)

formsButton.MouseButton1Click:Connect(function()
    SafeCall(onFormsButtonClick)
end)

local function Cal()
    local function updateFPS()
    local count, lastUpdate = 0, tick()

    RunService.RenderStepped:Connect(function()
        count = count + 1
        if tick() - lastUpdate >= 1 then
            fpsTextLabel.Text = "FPS: " .. count
            count, lastUpdate = 0, tick()
        end
    end)
end

    local function Serverping()
        local success, servers = pcall(function()
            return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")).data
        end)
        if not success then return "Error" end

        local bestPing = math.huge
        for _, server in ipairs(servers) do
            local ping = math.min((function() 
                local start = tick() 
                RunService.Stepped:wait() 
                return (tick() - start) * 1000 
            end)(), 1500)
            if ping < bestPing then 
                bestPing, bestId = ping, server.id 
            end
        end
        return bestPing < math.huge and math.floor(bestPing) .. "/Srv.." or "N/A"
    end

    button.MouseButton1Click:Connect(function()
    if bestId and #game.Players:GetPlayers() > 2 then
        pcall(function() 
            TeleportService:TeleportToPlaceInstance(game.PlaceId, bestId) 
        end) 
    end
end)

    while true do
        SafeCall(updateFPS)   
        SafeCall(updatePing)   
        SafeCall(updateTime())   
        button.Text = Serverping()
          task.wait(1/60) 
    end
end

SafeCall(Cal)
SafeCall(showPlayerThumbnail)

 end)

if not success then
    warn("Error en la inicialización: " .. tostring(fail))
end
