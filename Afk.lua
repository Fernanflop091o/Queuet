local screenGui = Instance.new("ScreenGui")
screenGui.ResetOnSpawn = false
local frame = Instance.new("Frame")
local textLabel = Instance.new("TextLabel")

screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

frame.Size = UDim2.new(0.3, 0, 0.2, 0)
frame.Position = UDim2.new(0.35, 0, 0.4, 0)
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
frame.BackgroundTransparency = 0.5
frame.BorderSizePixel = 0
frame.Parent = screenGui

textLabel.Size = UDim2.new(1, 0, 1, 0)
textLabel.BackgroundTransparency = 1
textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
textLabel.TextScaled = true
textLabel.TextWrapped = true
textLabel.Parent = frame

local function updateTime()
    while true do
        task.wait()
        
        local currentHour = math.floor(game.Lighting.ClockTime)
        local currentMinute = math.floor((game.Lighting.ClockTime % 1) * 60)

        textLabel.Text = string.format("%02d:%02d", currentHour, currentMinute)
    end
end

updateTime()
