local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- Cleanup previous UI
for _, gui in pairs(CoreGui:GetChildren()) do
    if gui.Name == "MinimalUI" then
        gui:Destroy()
    end
end

-- Colors
local COLORS = {
    Background = Color3.fromRGB(15, 15, 15),
    Secondary = Color3.fromRGB(20, 20, 20),
    Accent = Color3.fromRGB(90, 100, 255),
    Text = Color3.fromRGB(235, 235, 235),
    TextDark = Color3.fromRGB(160, 160, 160),
    Hover = Color3.fromRGB(25, 25, 25)
}

-- Create the UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MinimalUI"
ScreenGui.ResetOnSpawn = false

-- Handle different executors
pcall(function()
    if syn then
        syn.protect_gui(ScreenGui)
        ScreenGui.Parent = CoreGui
    elseif gethui then
        ScreenGui.Parent = gethui()
    else
        ScreenGui.Parent = CoreGui
    end
end)

-- Main Frame
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 400, 0, 300)
Main.Position = UDim2.new(0.5, -200, 0.5, -150)
Main.BackgroundColor3 = COLORS.Background
Main.BorderSizePixel = 0
Main.Parent = ScreenGui

-- Add corner radius
local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 6)
Corner.Parent = Main

-- Top Bar
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 32)
TopBar.BackgroundColor3 = COLORS.Secondary
TopBar.BorderSizePixel = 0
TopBar.Parent = Main

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 6)
TopCorner.Parent = TopBar

-- Title
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, -20, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Your Script Name"
Title.TextColor3 = COLORS.Text
Title.TextSize = 14
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

-- Content Area
local Content = Instance.new("Frame")
Content.Name = "Content"
Content.Size = UDim2.new(1, -20, 1, -42)
Content.Position = UDim2.new(0, 10, 0, 37)
Content.BackgroundColor3 = COLORS.Secondary
Content.BorderSizePixel = 0
Content.Parent = Main

local ContentCorner = Instance.new("UICorner")
ContentCorner.CornerRadius = UDim.new(0, 6)
ContentCorner.Parent = Content

-- Add some buttons
local function CreateButton(text, position, callback)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, -20, 0, 32)
    Button.Position = position
    Button.BackgroundColor3 = COLORS.Background
    Button.BorderSizePixel = 0
    Button.Text = text
    Button.TextColor3 = COLORS.Text
    Button.TextSize = 14
    Button.Font = Enum.Font.Gotham
    Button.Parent = Content
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 4)
    ButtonCorner.Parent = Button
    
    -- Hover effect
    Button.MouseEnter:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.2), {
            BackgroundColor3 = COLORS.Hover
        }):Play()
    end)
    
    Button.MouseLeave:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.2), {
            BackgroundColor3 = COLORS.Background
        }):Play()
    end)
    
    Button.MouseButton1Click:Connect(callback)
end

-- Add some example buttons
CreateButton("Button 1", UDim2.new(0, 10, 0, 10), function()
    print("Button 1 clicked!")
end)

CreateButton("Button 2", UDim2.new(0, 10, 0, 52), function()
    print("Button 2 clicked!")
end)

CreateButton("Button 3", UDim2.new(0, 10, 0, 94), function()
    print("Button 3 clicked!")
end)

-- Add a toggle
local function CreateToggle(text, position, callback)
    local Toggle = Instance.new("Frame")
    Toggle.Size = UDim2.new(1, -20, 0, 32)
    Toggle.Position = position
    Toggle.BackgroundColor3 = COLORS.Background
    Toggle.BorderSizePixel = 0
    Toggle.Parent = Content
    
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 4)
    ToggleCorner.Parent = Toggle
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -50, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = COLORS.Text
    Label.TextSize = 14
    Label.Font = Enum.Font.Gotham
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Toggle
    
    local Switch = Instance.new("Frame")
    Switch.Size = UDim2.new(0, 40, 0, 20)
    Switch.Position = UDim2.new(1, -45, 0.5, -10)
    Switch.BackgroundColor3 = COLORS.Secondary
    Switch.BorderSizePixel = 0
    Switch.Parent = Toggle
    
    local SwitchCorner = Instance.new("UICorner")
    SwitchCorner.CornerRadius = UDim.new(1, 0)
    SwitchCorner.Parent = Switch
    
    local Indicator = Instance.new("Frame")
    Indicator.Size = UDim2.new(0, 16, 0, 16)
    Indicator.Position = UDim2.new(0, 2, 0.5, -8)
    Indicator.BackgroundColor3 = COLORS.Text
    Indicator.BorderSizePixel = 0
    Indicator.Parent = Switch
    
    local IndicatorCorner = Instance.new("UICorner")
    IndicatorCorner.CornerRadius = UDim.new(1, 0)
    IndicatorCorner.Parent = Indicator
    
    local enabled = false
    
    local function updateToggle()
        TweenService:Create(Switch, TweenInfo.new(0.2), {
            BackgroundColor3 = enabled and COLORS.Accent or COLORS.Secondary
        }):Play()
        
        TweenService:Create(Indicator, TweenInfo.new(0.2), {
            Position = enabled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
        }):Play()
        
        callback(enabled)
    end
    
    Toggle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            enabled = not enabled
            updateToggle()
        end
    end)
end

-- Add example toggle
CreateToggle("Toggle Feature", UDim2.new(0, 10, 0, 136), function(enabled)
    print("Toggle is now:", enabled)
end)

-- Make window draggable
local dragging = false
local dragStart, startPos

TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = Main.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)
