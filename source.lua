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
    local window = {
        Tabs = {},
        CurrentTab = nil
    }
    
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
    Main.Size = UDim2.new(0, 450, 0, 300)  -- Made slightly wider for tabs
    Main.Position = UDim2.new(0.5, -225, 0.5, -150)
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
    
    -- Close Button
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Size = UDim2.new(0, 24, 0, 24)
    CloseButton.Position = UDim2.new(1, -30, 0.5, -12)
    CloseButton.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
    CloseButton.BackgroundTransparency = 1
    CloseButton.Text = "×"
    CloseButton.TextColor3 = Library.Theme.Text
    CloseButton.TextSize = 20
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Parent = TopBar
    
    -- Close button hover effect
    CloseButton.MouseEnter:Connect(function()
        TweenService:Create(CloseButton, TweenInfo.new(0.2), {
            BackgroundTransparency = 0
        }):Play()
    end)
    
    CloseButton.MouseLeave:Connect(function()
        TweenService:Create(CloseButton, TweenInfo.new(0.2), {
            BackgroundTransparency = 1
        }):Play()
    end)
    
    -- Close button functionality
    CloseButton.MouseButton1Click:Connect(function()
        -- Fade out animation
        local fadeOut = TweenService:Create(Main, TweenInfo.new(0.2), {
            BackgroundTransparency = 1
        })
        
        -- Fade out all children
        local function fadeOutChildren(parent)
            for _, child in pairs(parent:GetDescendants()) do
                if child:IsA("Frame") or child:IsA("TextButton") or child:IsA("TextLabel") or child:IsA("ScrollingFrame") then
                    TweenService:Create(child, TweenInfo.new(0.2), {
                        BackgroundTransparency = 1
                    }):Play()
                end
                if child:IsA("TextButton") or child:IsA("TextLabel") then
                    TweenService:Create(child, TweenInfo.new(0.2), {
                        TextTransparency = 1
                    }):Play()
                end
            end
        end
        
        fadeOutChildren(Main)
        fadeOut:Play()
        
        -- Destroy after fade out
        fadeOut.Completed:Connect(function()
            ScreenGui:Destroy()
        end)
    end)
    
    local CloseButtonCorner = Instance.new("UICorner")
    CloseButtonCorner.CornerRadius = UDim.new(0, 4)
    CloseButtonCorner.Parent = CloseButton
    
    -- Tab Bar
    local TabBar = Instance.new("Frame")
    TabBar.Name = "TabBar"
    TabBar.Size = UDim2.new(0, 130, 1, -32)
    TabBar.Position = UDim2.new(0, 0, 0, 32)
    TabBar.BackgroundColor3 = Library.Theme.Secondary
    TabBar.BorderSizePixel = 0
    TabBar.Parent = Main
    
    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Name = "TabContainer"
    TabContainer.Size = UDim2.new(1, -10, 1, -10)
    TabContainer.Position = UDim2.new(0, 5, 0, 5)
    TabContainer.BackgroundTransparency = 1
    TabContainer.ScrollBarThickness = 2
    TabContainer.ScrollBarImageColor3 = Library.Theme.Accent
    TabContainer.Parent = TabBar
    
    local TabList = Instance.new("UIListLayout")
    TabList.Padding = UDim.new(0, 5)
    TabList.Parent = TabContainer
    
    -- Content Area
    local ContentArea = Instance.new("Frame")
    ContentArea.Name = "ContentArea"
    ContentArea.Size = UDim2.new(1, -140, 1, -42)
    ContentArea.Position = UDim2.new(0, 135, 0, 37)
    ContentArea.BackgroundColor3 = Library.Theme.Secondary
    ContentArea.BorderSizePixel = 0
    ContentArea.Parent = Main
    
    local ContentCorner = Instance.new("UICorner")
    ContentCorner.CornerRadius = UDim.new(0, 6)
    ContentCorner.Parent = ContentArea
    
    -- Create Tab function
    function window:CreateTab(name)
        local tab = {
            Elements = {}
        }
        
        -- Tab Button
        local TabButton = Instance.new("TextButton")
        TabButton.Size = UDim2.new(1, -10, 0, 32)
        TabButton.BackgroundColor3 = Library.Theme.Background
        TabButton.BackgroundTransparency = 0.9
        TabButton.BorderSizePixel = 0
        TabButton.Text = name
        TabButton.TextColor3 = Library.Theme.DarkText
        TabButton.TextSize = 14
        TabButton.Font = Enum.Font.Gotham
        TabButton.Parent = TabContainer
        
        local TabButtonCorner = Instance.new("UICorner")
        TabButtonCorner.CornerRadius = UDim.new(0, 4)
        TabButtonCorner.Parent = TabButton
        
        -- Tab Content
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Size = UDim2.new(1, -20, 1, -20)
        TabContent.Position = UDim2.new(0, 10, 0, 10)
        TabContent.BackgroundTransparency = 1
        TabContent.ScrollBarThickness = 2
        TabContent.ScrollBarImageColor3 = Library.Theme.Accent
        TabContent.Visible = false
        TabContent.Parent = ContentArea
        
        local ElementList = Instance.new("UIListLayout")
        ElementList.Padding = UDim.new(0, 5)
        ElementList.Parent = TabContent
        
        -- Update canvas size when elements are added
        ElementList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabContent.CanvasSize = UDim2.new(0, 0, 0, ElementList.AbsoluteContentSize.Y + 10)
        end)
        
        -- Tab Button Click Handler
        TabButton.MouseButton1Click:Connect(function()
            -- Hide all other tabs
            for _, otherTab in pairs(window.Tabs) do
                otherTab.Content.Visible = false
                otherTab.Button.BackgroundTransparency = 0.9
                otherTab.Button.TextColor3 = Library.Theme.DarkText
            end
            
            -- Show current tab
            TabContent.Visible = true
            TabButton.BackgroundTransparency = 0
            TabButton.TextColor3 = Library.Theme.Text
            window.CurrentTab = tab
        end)
        
        -- Store tab data
        tab.Button = TabButton
        tab.Content = TabContent
        table.insert(window.Tabs, tab)
        
        -- Show first tab by default
        if #window.Tabs == 1 then
            TabContent.Visible = true
            TabButton.BackgroundTransparency = 0
            TabButton.TextColor3 = Library.Theme.Text
            window.CurrentTab = tab
        end
        
        -- Element Creators
        function tab:CreateButton(text, callback)
            callback = callback or function() end
            
            local Button = Instance.new("TextButton")
            Button.Size = UDim2.new(1, 0, 0, 32)
            Button.BackgroundColor3 = Library.Theme.Secondary
            Button.BorderSizePixel = 0
            Button.Text = text
            Button.TextColor3 = Library.Theme.Text
            Button.TextSize = 14
            Button.Font = Enum.Font.Gotham
            Button.Parent = TabContent
            
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
        
        function tab:CreateToggle(text, callback)
            callback = callback or function() end
            local enabled = false
            
            local Toggle = Instance.new("Frame")
            Toggle.Size = UDim2.new(1, 0, 0, 32)
            Toggle.BackgroundColor3 = Library.Theme.Secondary
            Toggle.BorderSizePixel = 0
            Toggle.Parent = TabContent
            
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
        
        return tab
    end
    
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
    
    return window
end

return Library
