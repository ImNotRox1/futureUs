local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

-- Clean up previous UIs
for _, gui in pairs(CoreGui:GetChildren()) do
    if gui.Name == "MoonUI" then
        gui:Destroy()
    end
end

-- Theme
local Theme = {
    Primary = Color3.fromRGB(30, 30, 35),
    Secondary = Color3.fromRGB(25, 25, 30),
    Accent = Color3.fromRGB(85, 100, 240),
    Text = Color3.fromRGB(240, 240, 240),
    TextDark = Color3.fromRGB(160, 160, 160),
    Background = Color3.fromRGB(20, 20, 25)
}

local Library = {}

function Library:CreateWindow(title)
    local Window = {}
    
    -- Main GUI
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "MoonUI"
    ScreenGui.Parent = CoreGui
    
    -- Main Frame
    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Size = UDim2.new(0, 550, 0, 350)
    Main.Position = UDim2.new(0.5, -275, 0.5, -175)
    Main.BackgroundColor3 = Theme.Background
    Main.BorderSizePixel = 0
    Main.Parent = ScreenGui
    
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 8)
    MainCorner.Parent = Main
    
    -- Title Bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Size = UDim2.new(1, 0, 0, 40)
    TitleBar.BackgroundColor3 = Theme.Primary
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = Main
    
    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 8)
    TitleCorner.Parent = TitleBar
    
    local TitleText = Instance.new("TextLabel")
    TitleText.Size = UDim2.new(1, -20, 1, 0)
    TitleText.Position = UDim2.new(0, 15, 0, 0)
    TitleText.BackgroundTransparency = 1
    TitleText.Text = title
    TitleText.TextColor3 = Theme.Text
    TitleText.TextSize = 15
    TitleText.Font = Enum.Font.GothamBold
    TitleText.TextXAlignment = Enum.TextXAlignment.Left
    TitleText.Parent = TitleBar
    
    -- Close Button
    local CloseButton = Instance.new("TextButton")
    CloseButton.Size = UDim2.new(0, 30, 0, 30)
    CloseButton.Position = UDim2.new(1, -35, 0, 5)
    CloseButton.BackgroundTransparency = 1
    CloseButton.Text = "×"
    CloseButton.TextColor3 = Theme.TextDark
    CloseButton.TextSize = 20
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Parent = TitleBar
    
    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)
    
    -- Make window draggable
    local Dragging = false
    local DragStart = nil
    local StartPos = nil
    
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            Dragging = true
            DragStart = input.Position
            StartPos = Main.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and Dragging then
            local Delta = input.Position - DragStart
            Main.Position = UDim2.new(
                StartPos.X.Scale,
                StartPos.X.Offset + Delta.X,
                StartPos.Y.Scale,
                StartPos.Y.Offset + Delta.Y
            )
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            Dragging = false
        end
    end)
    
    -- Tab System
    local TabButtons = Instance.new("Frame")
    TabButtons.Name = "TabButtons"
    TabButtons.Size = UDim2.new(0, 40, 1, -50)
    TabButtons.Position = UDim2.new(0, 10, 0, 45)
    TabButtons.BackgroundTransparency = 1
    TabButtons.Parent = Main
    
    local TabButtonList = Instance.new("UIListLayout")
    TabButtonList.Padding = UDim.new(0, 5)
    TabButtonList.Parent = TabButtons
    
    local TabPages = Instance.new("Frame")
    TabPages.Name = "TabPages"
    TabPages.Size = UDim2.new(1, -60, 1, -50)
    TabPages.Position = UDim2.new(0, 55, 0, 45)
    TabPages.BackgroundTransparency = 1
    TabPages.Parent = Main
    
    local Tabs = {}
    
    function Window:CreateTab(name)
        local Tab = {}
        
        -- Tab Button
        local TabButton = Instance.new("Frame")
        TabButton.Size = UDim2.new(1, 0, 0, 40)
        TabButton.BackgroundColor3 = Theme.Primary
        TabButton.BorderSizePixel = 0
        TabButton.Parent = TabButtons
        
        local TabButtonCorner = Instance.new("UICorner")
        TabButtonCorner.CornerRadius = UDim.new(0, 6)
        TabButtonCorner.Parent = TabButton
        
        local TabIcon = Instance.new("TextLabel")
        TabIcon.Size = UDim2.new(1, 0, 1, 0)
        TabIcon.BackgroundTransparency = 1
        TabIcon.Text = name:sub(1, 1)
        TabIcon.TextColor3 = Theme.TextDark
        TabIcon.TextSize = 16
        TabIcon.Font = Enum.Font.GothamBold
        TabIcon.Parent = TabButton
        
        -- Tab Page
        local TabPage = Instance.new("ScrollingFrame")
        TabPage.Size = UDim2.new(1, 0, 1, 0)
        TabPage.BackgroundTransparency = 1
        TabPage.BorderSizePixel = 0
        TabPage.ScrollBarThickness = 2
        TabPage.ScrollBarImageColor3 = Theme.Accent
        TabPage.Visible = false
        TabPage.Parent = TabPages
        
        local TabPageList = Instance.new("UIListLayout")
        TabPageList.Padding = UDim.new(0, 10)
        TabPageList.Parent = TabPage
        
        -- Auto-size canvas
        TabPageList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabPage.CanvasSize = UDim2.new(0, 0, 0, TabPageList.AbsoluteContentSize.Y)
        end)
        
        -- Tab Selection
        local TabButton = Instance.new("TextButton")
        TabButton.Size = UDim2.new(1, 0, 1, 0)
        TabButton.BackgroundTransparency = 1
        TabButton.Text = ""
        TabButton.Parent = TabButton
        
        TabButton.MouseButton1Click:Connect(function()
            for _, tab in pairs(Tabs) do
                tab.Page.Visible = false
                tab.Icon.TextColor3 = Theme.TextDark
            end
            TabPage.Visible = true
            TabIcon.TextColor3 = Theme.Text
        end)
        
        -- Store tab data
        table.insert(Tabs, {
            Page = TabPage,
            Icon = TabIcon
        })
        
        -- Select first tab
        if #Tabs == 1 then
            TabPage.Visible = true
            TabIcon.TextColor3 = Theme.Text
        end
        
        function Tab:CreateSection(name)
            local Section = {}
            
            local SectionFrame = Instance.new("Frame")
            SectionFrame.Size = UDim2.new(1, -20, 0, 30)
            SectionFrame.BackgroundColor3 = Theme.Primary
            SectionFrame.BorderSizePixel = 0
            SectionFrame.Parent = TabPage
            
            local SectionCorner = Instance.new("UICorner")
            SectionCorner.CornerRadius = UDim.new(0, 6)
            SectionCorner.Parent = SectionFrame
            
            local SectionTitle = Instance.new("TextLabel")
            SectionTitle.Size = UDim2.new(1, -15, 0, 30)
            SectionTitle.Position = UDim2.new(0, 15, 0, 0)
            SectionTitle.BackgroundTransparency = 1
            SectionTitle.Text = name
            SectionTitle.TextColor3 = Theme.TextDark
            SectionTitle.TextSize = 14
            SectionTitle.Font = Enum.Font.GothamBold
            SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
            SectionTitle.Parent = SectionFrame
            
            local SectionContent = Instance.new("Frame")
            SectionContent.Name = "Content"
            SectionContent.Size = UDim2.new(1, 0, 0, 0)
            SectionContent.Position = UDim2.new(0, 0, 0, 35)
            SectionContent.BackgroundTransparency = 1
            SectionContent.Parent = SectionFrame
            
            local ContentList = Instance.new("UIListLayout")
            ContentList.Padding = UDim.new(0, 5)
            ContentList.Parent = SectionContent
            
            -- Auto-size section
            ContentList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                SectionFrame.Size = UDim2.new(1, -20, 0, ContentList.AbsoluteContentSize.Y + 40)
            end)
            
            -- Section Elements
            function Section:CreateToggle(text, callback)
                callback = callback or function() end
                
                local Toggle = Instance.new("Frame")
                Toggle.Size = UDim2.new(1, 0, 0, 35)
                Toggle.BackgroundColor3 = Theme.Secondary
                Toggle.BorderSizePixel = 0
                Toggle.Parent = SectionContent
                
                local ToggleCorner = Instance.new("UICorner")
                ToggleCorner.CornerRadius = UDim.new(0, 6)
                ToggleCorner.Parent = Toggle
                
                local ToggleTitle = Instance.new("TextLabel")
                ToggleTitle.Size = UDim2.new(1, -50, 1, 0)
                ToggleTitle.Position = UDim2.new(0, 15, 0, 0)
                ToggleTitle.BackgroundTransparency = 1
                ToggleTitle.Text = text
                ToggleTitle.TextColor3 = Theme.Text
                ToggleTitle.TextSize = 14
                ToggleTitle.Font = Enum.Font.Gotham
                ToggleTitle.TextXAlignment = Enum.TextXAlignment.Left
                ToggleTitle.Parent = Toggle
                
                local ToggleButton = Instance.new("Frame")
                ToggleButton.Size = UDim2.new(0, 45, 0, 25)
                ToggleButton.Position = UDim2.new(1, -55, 0.5, -12.5)
                ToggleButton.BackgroundColor3 = Theme.Primary
                ToggleButton.BorderSizePixel = 0
                ToggleButton.Parent = Toggle
                
                local ToggleButtonCorner = Instance.new("UICorner")
                ToggleButtonCorner.CornerRadius = UDim.new(1, 0)
                ToggleButtonCorner.Parent = ToggleButton
                
                local ToggleIndicator = Instance.new("Frame")
                ToggleIndicator.Size = UDim2.new(0, 21, 0, 21)
                ToggleIndicator.Position = UDim2.new(0, 2, 0.5, -10.5)
                ToggleIndicator.BackgroundColor3 = Theme.Text
                ToggleIndicator.BorderSizePixel = 0
                ToggleIndicator.Parent = ToggleButton
                
                local ToggleIndicatorCorner = Instance.new("UICorner")
                ToggleIndicatorCorner.CornerRadius = UDim.new(1, 0)
                ToggleIndicatorCorner.Parent = ToggleIndicator
                
                local Enabled = false
                
                local ToggleClick = Instance.new("TextButton")
                ToggleClick.Size = UDim2.new(1, 0, 1, 0)
                ToggleClick.BackgroundTransparency = 1
                ToggleClick.Text = ""
                ToggleClick.Parent = Toggle
                
                ToggleClick.MouseButton1Click:Connect(function()
                    Enabled = not Enabled
                    
                    TweenService:Create(ToggleButton, TweenInfo.new(0.15), {
                        BackgroundColor3 = Enabled and Theme.Accent or Theme.Primary
                    }):Play()
                    
                    TweenService:Create(ToggleIndicator, TweenInfo.new(0.15), {
                        Position = Enabled and UDim2.new(1, -23, 0.5, -10.5) or UDim2.new(0, 2, 0.5, -10.5)
                    }):Play()
                    
                    callback(Enabled)
                end)
                
                return {
                    SetValue = function(value)
                        Enabled = value
                        TweenService:Create(ToggleButton, TweenInfo.new(0.15), {
                            BackgroundColor3 = Enabled and Theme.Accent or Theme.Primary
                        }):Play()
                        TweenService:Create(ToggleIndicator, TweenInfo.new(0.15), {
                            Position = Enabled and UDim2.new(1, -23, 0.5, -10.5) or UDim2.new(0, 2, 0.5, -10.5)
                        }):Play()
                        callback(Enabled)
                    end,
                    GetValue = function()
                        return Enabled
                    end
                }
            end
            
            function Section:CreateButton(text, callback)
                callback = callback or function() end
                
                local Button = Instance.new("Frame")
                Button.Size = UDim2.new(1, 0, 0, 35)
                Button.BackgroundColor3 = Theme.Secondary
                Button.BorderSizePixel = 0
                Button.Parent = SectionContent
                
                local ButtonCorner = Instance.new("UICorner")
                ButtonCorner.CornerRadius = UDim.new(0, 6)
                ButtonCorner.Parent = Button
                
                local ButtonTitle = Instance.new("TextLabel")
                ButtonTitle.Size = UDim2.new(1, 0, 1, 0)
                ButtonTitle.BackgroundTransparency = 1
                ButtonTitle.Text = text
                ButtonTitle.TextColor3 = Theme.Text
                ButtonTitle.TextSize = 14
                ButtonTitle.Font = Enum.Font.Gotham
                ButtonTitle.Parent = Button
                
                local ButtonClick = Instance.new("TextButton")
                ButtonClick.Size = UDim2.new(1, 0, 1, 0)
                ButtonClick.BackgroundTransparency = 1
                ButtonClick.Text = ""
                ButtonClick.Parent = Button
                
                ButtonClick.MouseButton1Click:Connect(callback)
                
                return Button
            end
            
            function Section:CreateSlider(text, min, max, default, callback)
                callback = callback or function() end
                min = min or 0
                max = max or 100
                default = default or min
                
                local Slider = Instance.new("Frame")
                Slider.Size = UDim2.new(1, 0, 0, 50)
                Slider.BackgroundColor3 = Theme.Secondary
                Slider.BorderSizePixel = 0
                Slider.Parent = SectionContent
                
                local SliderCorner = Instance.new("UICorner")
                SliderCorner.CornerRadius = UDim.new(0, 6)
                SliderCorner.Parent = Slider
                
                local SliderTitle = Instance.new("TextLabel")
                SliderTitle.Size = UDim2.new(1, -65, 0, 30)
                SliderTitle.Position = UDim2.new(0, 15, 0, 0)
                SliderTitle.BackgroundTransparency = 1
                SliderTitle.Text = text
                SliderTitle.TextColor3 = Theme.Text
                SliderTitle.TextSize = 14
                SliderTitle.Font = Enum.Font.Gotham
                SliderTitle.TextXAlignment = Enum.TextXAlignment.Left
                SliderTitle.Parent = Slider
                
                local SliderValue = Instance.new("TextBox")
                SliderValue.Size = UDim2.new(0, 40, 0, 30)
                SliderValue.Position = UDim2.new(1, -55, 0, 0)
                SliderValue.BackgroundTransparency = 1
                SliderValue.Text = tostring(default)
                SliderValue.TextColor3 = Theme.TextDark
                SliderValue.TextSize = 14
                SliderValue.Font = Enum.Font.Gotham
                SliderValue.Parent = Slider
                
                local SliderBar = Instance.new("Frame")
                SliderBar.Size = UDim2.new(1, -30, 0, 4)
                SliderBar.Position = UDim2.new(0, 15, 0, 38)
                SliderBar.BackgroundColor3 = Theme.Primary
                SliderBar.BorderSizePixel = 0
                SliderBar.Parent = Slider
                
                local SliderBarCorner = Instance.new("UICorner")
                SliderBarCorner.CornerRadius = UDim.new(1, 0)
                SliderBarCorner.Parent = SliderBar
                
                local SliderFill = Instance.new("Frame")
                SliderFill.Size = UDim2.new((default - min)/(max - min), 0, 1, 0)
                SliderFill.BackgroundColor3 = Theme.Accent
                SliderFill.BorderSizePixel = 0
                SliderFill.Parent = SliderBar
                
                local SliderFillCorner = Instance.new("UICorner")
                SliderFillCorner.CornerRadius = UDim.new(1, 0)
                SliderFillCorner.Parent = SliderFill
                
                local IsDragging = false
                
                local function Update(input)
                    local pos = UDim2.new(
                        math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1),
                        0,
                        1,
                        0
                    )
                    SliderFill.Size = pos
                    
                    local value = math.floor(min + ((max - min) * pos.X.Scale))
                    SliderValue.Text = tostring(value)
                    callback(value)
                end
                
                SliderBar.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        IsDragging = true
                        Update(input)
                    end
                end)
                
                UserInputService.InputChanged:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseMovement and IsDragging then
                        Update(input)
                    end
                end)
                
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        IsDragging = false
                    end
                end)
                
                SliderValue.FocusLost:Connect(function()
                    local num = tonumber(SliderValue.Text)
                    if num then
                        num = math.clamp(num, min, max)
                        SliderValue.Text = tostring(num)
                        SliderFill.Size = UDim2.new((num - min)/(max - min), 0, 1, 0)
                        callback(num)
                    else
                        SliderValue.Text = tostring(min + ((max - min) * SliderFill.Size.X.Scale))
                    end
                end)
                
                return {
                    SetValue = function(value)
                        local num = math.clamp(value, min, max)
                        SliderValue.Text = tostring(num)
                        SliderFill.Size = UDim2.new((num - min)/(max - min), 0, 1, 0)
                        callback(num)
                    end,
                    GetValue = function()
                        return tonumber(SliderValue.Text)
                    end
                }
            end
            
            function Section:CreateSelector(text, options, callback)
                callback = callback or function() end
                
                local Selector = Instance.new("Frame")
                Selector.Size = UDim2.new(1, 0, 0, 35)
                Selector.BackgroundColor3 = Theme.Secondary
                Selector.BorderSizePixel = 0
                Selector.Parent = SectionContent
                
                local SelectorCorner = Instance.new("UICorner")
                SelectorCorner.CornerRadius = UDim.new(0, 6)
                SelectorCorner.Parent = Selector
                
                local SelectorTitle = Instance.new("TextLabel")
                SelectorTitle.Size = UDim2.new(1, -50, 1, 0)
                SelectorTitle.Position = UDim2.new(0, 15, 0, 0)
                SelectorTitle.BackgroundTransparency = 1
                SelectorTitle.Text = text
                SelectorTitle.TextColor3 = Theme.Text
                SelectorTitle.TextSize = 14
                SelectorTitle.Font = Enum.Font.Gotham
                SelectorTitle.TextXAlignment = Enum.TextXAlignment.Left
                SelectorTitle.Parent = Selector
                
                local Selected = Instance.new("TextLabel")
                Selected.Size = UDim2.new(0, 100, 1, 0)
                Selected.Position = UDim2.new(1, -115, 0, 0)
                Selected.BackgroundTransparency = 1
                Selected.Text = options[1] or "None"
                Selected.TextColor3 = Theme.TextDark
                Selected.TextSize = 14
                Selected.Font = Enum.Font.Gotham
                Selected.TextXAlignment = Enum.TextXAlignment.Right
                Selected.Parent = Selector
                
                local NextButton = Instance.new("TextButton")
                NextButton.Size = UDim2.new(0, 20, 1, 0)
                NextButton.Position = UDim2.new(1, -20, 0, 0)
                NextButton.BackgroundTransparency = 1
                NextButton.Text = ">"
                NextButton.TextColor3 = Theme.TextDark
                NextButton.TextSize = 14
                NextButton.Font = Enum.Font.Gotham
                NextButton.Parent = Selector
                
                local currentIndex = 1
                
                NextButton.MouseButton1Click:Connect(function()
                    currentIndex = currentIndex % #options + 1
                    Selected.Text = options[currentIndex]
                    callback(options[currentIndex])
                end)
                
                return {
                    SetValue = function(option)
                        for i, v in ipairs(options) do
                            if v == option then
                                currentIndex = i
                                Selected.Text = option
                                callback(option)
                                break
                            end
                        end
                    end,
                    GetValue = function()
                        return Selected.Text
                    end
                }
            end
            
            return Section
        end
        
        return Tab
    end
    
    return Window
end

return Library
