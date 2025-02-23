local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local Library = {
    Theme = {
        Background = Color3.fromRGB(15, 15, 15),
        Secondary = Color3.fromRGB(20, 20, 20),
        Accent = Color3.fromRGB(100, 100, 255),
        Text = Color3.fromRGB(235, 235, 235),
        DarkText = Color3.fromRGB(175, 175, 175)
    }
}

function Library:CreateWindow(title)
    local window = {}
    
    -- Cleanup previous UI
    for _, gui in pairs(CoreGui:GetChildren()) do
        if gui.Name == "MinimalUI" then
            gui:Destroy()
        end
    end
    
    -- Create ScreenGui
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
    Main.BackgroundColor3 = Library.Theme.Background
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
    TopBar.BackgroundColor3 = Library.Theme.Secondary
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
    Title.Text = title
    Title.TextColor3 = Library.Theme.Text
    Title.TextSize = 14
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TopBar
    
    -- Content Area
    local Content = Instance.new("Frame")
    Content.Name = "Content"
    Content.Size = UDim2.new(1, -20, 1, -42)
    Content.Position = UDim2.new(0, 10, 0, 37)
    Content.BackgroundTransparency = 1
    Content.Parent = Main
    
    -- Element List
    local ElementList = Instance.new("UIListLayout")
    ElementList.Padding = UDim.new(0, 5)
    ElementList.Parent = Content
    
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
    
    -- Button Creator
    function window:CreateButton(text, callback)
        callback = callback or function() end
        
        local Button = Instance.new("TextButton")
        Button.Size = UDim2.new(1, 0, 0, 32)
        Button.BackgroundColor3 = Library.Theme.Secondary
        Button.BorderSizePixel = 0
        Button.Text = text
        Button.TextColor3 = Library.Theme.Text
        Button.TextSize = 14
        Button.Font = Enum.Font.Gotham
        Button.Parent = Content
        
        local ButtonCorner = Instance.new("UICorner")
        ButtonCorner.CornerRadius = UDim.new(0, 4)
        ButtonCorner.Parent = Button
        
        Button.MouseEnter:Connect(function()
            TweenService:Create(Button, TweenInfo.new(0.2), {
                BackgroundColor3 = Library.Theme.Accent
            }):Play()
        end)
        
        Button.MouseLeave:Connect(function()
            TweenService:Create(Button, TweenInfo.new(0.2), {
                BackgroundColor3 = Library.Theme.Secondary
            }):Play()
        end)
        
        Button.MouseButton1Click:Connect(callback)
        return Button
    end
    
    -- Toggle Creator
    function window:CreateToggle(text, callback)
        callback = callback or function() end
        local enabled = false
        
        local Toggle = Instance.new("Frame")
        Toggle.Size = UDim2.new(1, 0, 0, 32)
        Toggle.BackgroundColor3 = Library.Theme.Secondary
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
        Label.TextColor3 = Library.Theme.Text
        Label.TextSize = 14
        Label.Font = Enum.Font.Gotham
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = Toggle
        
        local Switch = Instance.new("Frame")
        Switch.Size = UDim2.new(0, 40, 0, 20)
        Switch.Position = UDim2.new(1, -45, 0.5, -10)
        Switch.BackgroundColor3 = Library.Theme.Background
        Switch.BorderSizePixel = 0
        Switch.Parent = Toggle
        
        local SwitchCorner = Instance.new("UICorner")
        SwitchCorner.CornerRadius = UDim.new(1, 0)
        SwitchCorner.Parent = Switch
        
        local Indicator = Instance.new("Frame")
        Indicator.Size = UDim2.new(0, 16, 0, 16)
        Indicator.Position = UDim2.new(0, 2, 0.5, -8)
        Indicator.BackgroundColor3 = Library.Theme.Text
        Indicator.BorderSizePixel = 0
        Indicator.Parent = Switch
        
        local IndicatorCorner = Instance.new("UICorner")
        IndicatorCorner.CornerRadius = UDim.new(1, 0)
        IndicatorCorner.Parent = Indicator
        
        local function updateToggle()
            TweenService:Create(Switch, TweenInfo.new(0.2), {
                BackgroundColor3 = enabled and Library.Theme.Accent or Library.Theme.Background
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
        
        return {
            Set = function(state)
                enabled = state
                updateToggle()
            end,
            Get = function()
                return enabled
            end
        }
    end
    
    return window
end

return Library
