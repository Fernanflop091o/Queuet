local screenGui = Instance.new("ScreenGui")
local buttonS = Instance.new("TextButton")
local buttonL = Instance.new("TextButton")

screenGui.Parent = game.CoreGui

buttonS.Size = UDim2.new(0, 18, 0, 33)
buttonS.Position = UDim2.new(1, -88, 0, -33)
buttonS.BackgroundColor3 = Color3.new(1, 1, 1)
buttonS.BackgroundTransparency = 0.5
buttonS.TextColor3 = Color3.new(0, 0, 1)
buttonS.Font = Enum.Font.GothamBold
buttonS.TextSize = 37
buttonS.Text = "S"
buttonS.Style = Enum.ButtonStyle.RobloxRoundDropdownButton
buttonS.Parent = screenGui

buttonL.Size = UDim2.new(0, 18, 0, 33)
buttonL.Position = UDim2.new(1, -62, 0, -33)
buttonL.BackgroundColor3 = Color3.new(0, 0, 0)
buttonL.BackgroundTransparency = 0.5
buttonL.TextColor3 = Color3.new(0.6, 0, 0)
buttonL.Font = Enum.Font.GothamBold
buttonL.TextSize = 37
buttonL.Text = "H"
buttonL.Style = Enum.ButtonStyle.RobloxRoundDropdownButton
buttonL.Parent = screenGui

local function animateButtonColor(button)
    while true do
        pcall(function()
            button.BackgroundColor3 = Color3.new(1, 1, 1)
            wait(0.25)
            button.BackgroundColor3 = Color3.new(0, 0, 0)
            wait(0.25)
        end)
    end
end

coroutine.wrap(function() animateButtonColor(buttonS) end)()
coroutine.wrap(function() animateButtonColor(buttonL) end)()

buttonS.MouseButton1Click:Connect(function()
    pcall(function()
        print("Botón S clickeado")
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Fernanflop091o/PARA_AMIGOS-ASER-SCRITP/refs/heads/main/GuionServer.lua"))()
    end)
end)

buttonL.MouseButton1Click:Connect(function()
    pcall(function()
        print("Botón L clickeado")
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Fernanflop091o/Prueba/refs/heads/main/Auto2.lua"))()
    end)
end)
