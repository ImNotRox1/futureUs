local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

-- Clean up previous UIs
local function DestroyUI()
    for _, gui in pairs(CoreGui:GetChildren()) do
        if gui.Name == "UI" then
            gui:Destroy()
        end
    end
end

DestroyUI()

-- Define colors
local COLORS = {
    Background = Color3.fromRGB(18, 18, 24),
    Secondary = Color3.fromRGB(22, 22, 30),
    Accent = Color3.fromRGB(85, 100, 240),
    Text = Color3.fromRGB(240, 240, 240),
    TextDark = Color3.fromRGB(160, 160, 160),
    TabBackground = Color3.fromRGB(15, 15, 20)
}

-- Create Library
local Library = {}

-- Helper function to create sections
local function CreateSection(name, parent)
    local Section = Instance.new("Frame")
    Section.Name = name.."Section"
    Section.Size = UDim2.new(1, 0, 0, 0)
    Section.BackgroundTransparency = 1
    Section.Parent = parent
    
    local SectionContent = Instance.new("Frame")
    SectionContent.Name = "SectionContent"
    SectionContent.Size = UDim2.new(1, 0, 1, 0)
    SectionContent.BackgroundTransparency = 1
    SectionContent.Parent = Section
    
    local SectionList = Instance.new("UIListLayout")
    SectionList.Padding = UDim.new(0, 6)
    SectionList.Parent = SectionContent
    
    -- Auto-adjust section size
    SectionList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Section.Size = UDim2.new(1, 0, 0, SectionList.AbsoluteContentSize.Y)
    end)
    
    local SectionFunctions = {
        CreateToggle = function(text, callback)
            callback = callback or function() end
            
            local Toggle = Instance.new("Frame")
            Toggle.Size = UDim2.new(1, 0, 0, 32)
            Toggle.BackgroundColor3 = COLORS.Background
            Toggle.BorderSizePixel = 0
            Toggle.Parent = SectionContent
            
            local ToggleCorner = Instance.new("UICorner")
            ToggleCorner.CornerRadius = UDim.new(0, 6)
            ToggleCorner.Parent = Toggle
            
            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, -50, 1, 0)
            Label.Position = UDim2.new(0, 15, 0, 0)
            Label.BackgroundTransparency = 1
            Label.Text = text
            Label.TextColor3 = COLORS.Text
            Label.TextSize = 14
            Label.Font = Enum.Font.Gotham
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = Toggle
            
            local Switch = Instance.new("Frame")
            Switch.Size = UDim2.new(0, 40, 0, 20)
            Switch.Position = UDim2.new(1, -55, 0.5, -10)
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
            
            local Enabled = false
            
            local Button = Instance.new("TextButton")
            Button.Size = UDim2.new(1, 0, 1, 0)
            Button.BackgroundTransparency = 1
            Button.Text = ""
            Button.Parent = Toggle
            
            Button.MouseButton1Click:Connect(function()
                Enabled = not Enabled
                
                TweenService:Create(Switch, TweenInfo.new(0.2), {
                    BackgroundColor3 = Enabled and COLORS.Accent or COLORS.Secondary
                }):Play()
                
                TweenService:Create(Indicator, TweenInfo.new(0.2), {
                    Position = Enabled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
                }):Play()
                
                callback(Enabled)
            end)
            
            return {
                SetValue = function(value)
                    Enabled = value
                    TweenService:Create(Switch, TweenInfo.new(0.2), {
                        BackgroundColor3 = Enabled and COLORS.Accent or COLORS.Secondary
                    }):Play()
                    TweenService:Create(Indicator, TweenInfo.new(0.2), {
                        Position = Enabled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
                    }):Play()
                    callback(Enabled)
                end,
                GetValue = function()
                    return Enabled
                end
            }
        end,
        
        CreateButton = function(text, callback)
            callback = callback or function() end
            
            local Button = Instance.new("Frame")
            Button.Size = UDim2.new(1, 0, 0, 32)
            Button.BackgroundColor3 = COLORS.Background
            Button.BorderSizePixel = 0
            Button.Parent = SectionContent
            
            local ButtonCorner = Instance.new("UICorner")
            ButtonCorner.CornerRadius = UDim.new(0, 6)
            ButtonCorner.Parent = Button
            
            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, 0, 1, 0)
            Label.BackgroundTransparency = 1
            Label.Text = text
            Label.TextColor3 = COLORS.Text
            Label.TextSize = 14
            Label.Font = Enum.Font.Gotham
            Label.Parent = Button
            
            local Click = Instance.new("TextButton")
            Click.Size = UDim2.new(1, 0, 1, 0)
            Click.BackgroundTransparency = 1
            Click.Text = ""
            Click.Parent = Button
            
            Click.MouseButton1Click:Connect(callback)
            
            return Button
        end,
        
        CreateSlider = function(text, min, max, default, callback)
            callback = callback or function() end
            min = min or 0
            max = max or 100
            default = default or min
            
            local Slider = Instance.new("Frame")
            Slider.Size = UDim2.new(1, 0, 0, 50)
            Slider.BackgroundColor3 = COLORS.Background
            Slider.BorderSizePixel = 0
            Slider.Parent = SectionContent
            
            local SliderCorner = Instance.new("UICorner")
            SliderCorner.CornerRadius = UDim.new(0, 6)
            SliderCorner.Parent = Slider
            
            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, -65, 0, 30)
            Label.Position = UDim2.new(0, 15, 0, 0)
            Label.BackgroundTransparency = 1
            Label.Text = text
            Label.TextColor3 = COLORS.Text
            Label.TextSize = 14
            Label.Font = Enum.Font.Gotham
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = Slider
            
            local Value = Instance.new("TextBox")
            Value.Size = UDim2.new(0, 40, 0, 30)
            Value.Position = UDim2.new(1, -55, 0, 0)
            Value.BackgroundTransparency = 1
            Value.Text = tostring(default)
            Value.TextColor3 = COLORS.TextDark
            Value.TextSize = 14
            Value.Font = Enum.Font.Gotham
            Value.Parent = Slider
            
            local SliderBar = Instance.new("Frame")
            SliderBar.Size = UDim2.new(1, -30, 0, 4)
            SliderBar.Position = UDim2.new(0, 15, 0, 38)
            SliderBar.BackgroundColor3 = COLORS.Secondary
            SliderBar.BorderSizePixel = 0
            SliderBar.Parent = Slider
            
            local SliderBarCorner = Instance.new("UICorner")
            SliderBarCorner.CornerRadius = UDim.new(1, 0)
            SliderBarCorner.Parent = SliderBar
            
            local SliderFill = Instance.new("Frame")
            SliderFill.Size = UDim2.new((default - min)/(max - min), 0, 1, 0)
            SliderFill.BackgroundColor3 = COLORS.Accent
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
                Value.Text = tostring(value)
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
            
            Value.FocusLost:Connect(function()
                local num = tonumber(Value.Text)
                if num then
                    num = math.clamp(num, min, max)
                    Value.Text = tostring(num)
                    SliderFill.Size = UDim2.new((num - min)/(max - min), 0, 1, 0)
                    callback(num)
                else
                    Value.Text = tostring(min + ((max - min) * SliderFill.Size.X.Scale))
                end
            end)
            
            return {
                SetValue = function(value)
                    local num = math.clamp(value, min, max)
                    Value.Text = tostring(num)
                    SliderFill.Size = UDim2.new((num - min)/(max - min), 0, 1, 0)
                    callback(num)
                end,
                GetValue = function()
                    return tonumber(Value.Text)
                end
            }
        end,
        
        CreateSelector = function(text, options, callback)
            callback = callback or function() end
            
            local Selector = Instance.new("Frame")
            Selector.Size = UDim2.new(1, 0, 0, 32)
            Selector.BackgroundColor3 = COLORS.Background
            Selector.BorderSizePixel = 0
            Selector.Parent = SectionContent
            
            local SelectorCorner = Instance.new("UICorner")
            SelectorCorner.CornerRadius = UDim.new(0, 6)
            SelectorCorner.Parent = Selector
            
            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, -50, 1, 0)
            Label.Position = UDim2.new(0, 15, 0, 0)
            Label.BackgroundTransparency = 1
            Label.Text = text
            Label.TextColor3 = COLORS.Text
            Label.TextSize = 14
            Label.Font = Enum.Font.Gotham
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = Selector
            
            local Selected = Instance.new("TextLabel")
            Selected.Size = UDim2.new(0, 100, 1, 0)
            Selected.Position = UDim2.new(1, -115, 0, 0)
            Selected.BackgroundTransparency = 1
            Selected.Text = options[1] or "None"
            Selected.TextColor3 = COLORS.TextDark
            Selected.TextSize = 14
            Selected.Font = Enum.Font.Gotham
            Selected.TextXAlignment = Enum.TextXAlignment.Right
            Selected.Parent = Selector
            
            local NextButton = Instance.new("TextButton")
            NextButton.Size = UDim2.new(0, 20, 1, 0)
            NextButton.Position = UDim2.new(1, -20, 0, 0)
            NextButton.BackgroundTransparency = 1
            NextButton.Text = ">"
            NextButton.TextColor3 = COLORS.TextDark
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
    }
    
    return SectionFunctions
end

function Library:CreateWindow(name)
    local Window = {}
    
    -- Create main GUI
    local Main = Instance.new("ScreenGui")
    Main.Name = "UI"
    Main.Parent = CoreGui
    
    -- Create main frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "Main"
    MainFrame.Size = UDim2.new(0, 500, 0, 600)
    MainFrame.Position = UDim2.new(0.5, -250, 0.5, -300)
    MainFrame.BackgroundColor3 = COLORS.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = Main
    
    -- Add corner
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 6)
    MainCorner.Parent = MainFrame
    
    -- Create title
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -20, 0, 30)
    Title.Position = UDim2.new(0, 10, 0, 10)
    Title.BackgroundTransparency = 1
    Title.Text = name
    Title.TextColor3 = COLORS.Text
    Title.TextSize = 16
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = MainFrame
    
    -- Create tab container
    local TabContainer = Instance.new("Frame")
    TabContainer.Name = "TabContainer"
    TabContainer.Size = UDim2.new(0, 40, 1, -60)
    TabContainer.Position = UDim2.new(0, 10, 0, 50)
    TabContainer.BackgroundTransparency = 1
    TabContainer.Parent = MainFrame
    
    -- Create page container
    local PageContainer = Instance.new("Frame")
    PageContainer.Name = "PageContainer"
    PageContainer.Size = UDim2.new(1, -70, 1, -60)
    PageContainer.Position = UDim2.new(0, 60, 0, 50)
    PageContainer.BackgroundTransparency = 1
    PageContainer.Parent = MainFrame
    
    -- Make window draggable
    local Dragging = false
    local DragStart = nil
    local StartPos = nil
    
    Title.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            Dragging = true
            DragStart = input.Position
            StartPos = MainFrame.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and Dragging then
            local Delta = input.Position - DragStart
            MainFrame.Position = UDim2.new(
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
    
    -- Add close button
    local CloseButton = Instance.new("TextButton")
    CloseButton.Size = UDim2.new(0, 20, 0, 20)
    CloseButton.Position = UDim2.new(1, -30, 0, 15)
    CloseButton.BackgroundTransparency = 1
    CloseButton.Text = "×"
    CloseButton.TextColor3 = COLORS.TextDark
    CloseButton.TextSize = 20
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Parent = MainFrame
    
    CloseButton.MouseButton1Click:Connect(function()
        Main:Destroy()
    end)

    -- Store all tabs
    local Tabs = {}

    -- Function to create tabs
    function Window:CreateTab(name)
        local Tab = {}
        
        -- Create tab button
        local TabButton = Instance.new("Frame")
        TabButton.Size = UDim2.new(1, 0, 0, 40)
        TabButton.BackgroundColor3 = COLORS.TabBackground
        TabButton.BorderSizePixel = 0
        TabButton.Parent = TabContainer
        
        local TabCorner = Instance.new("UICorner")
        TabCorner.CornerRadius = UDim.new(0, 6)
        TabCorner.Parent = TabButton
        
        local TabIcon = Instance.new("TextLabel")
        TabIcon.Size = UDim2.new(1, 0, 1, 0)
        TabIcon.BackgroundTransparency = 1
        TabIcon.Text = name:sub(1, 1)
        TabIcon.TextColor3 = COLORS.TextDark
        TabIcon.TextSize = 16
        TabIcon.Font = Enum.Font.GothamBold
        TabIcon.Parent = TabButton
        
        local SelectionIndicator = Instance.new("Frame")
        SelectionIndicator.Name = "SelectionIndicator"
        SelectionIndicator.Size = UDim2.new(0, 2, 0.8, 0)
        SelectionIndicator.Position = UDim2.new(0, 0, 0.1, 0)
        SelectionIndicator.BackgroundColor3 = COLORS.Accent
        SelectionIndicator.BorderSizePixel = 0
        SelectionIndicator.Visible = false
        SelectionIndicator.Parent = TabButton
        
        -- Create page for this tab
        local PageHolder = Instance.new("Frame")
        PageHolder.Name = name.."PageHolder"
        PageHolder.Size = UDim2.new(1, 0, 1, 0)
        PageHolder.BackgroundTransparency = 1
        PageHolder.ClipsDescendants = true
        PageHolder.Visible = false
        PageHolder.Parent = PageContainer
        
        local Page = Instance.new("ScrollingFrame")
        Page.Name = name.."Page"
        Page.Size = UDim2.new(1, -5, 1, 0)
        Page.BackgroundTransparency = 1
        Page.BorderSizePixel = 0
        Page.ScrollBarThickness = 2
        Page.ScrollBarImageColor3 = COLORS.Accent
        Page.CanvasSize = UDim2.new(0, 0, 0, 0)
        Page.ClipsDescendants = true
        Page.Parent = PageHolder
        
        local PageList = Instance.new("UIListLayout")
        PageList.Padding = UDim.new(0, 6)
        PageList.Parent = Page
        
        -- Store tab data
        local tab = {
            Button = TabButton,
            Page = PageHolder,
            Icon = TabIcon,
            Indicator = SelectionIndicator
        }
        table.insert(Tabs, tab)
        
        -- Handle tab selection
        local Button = Instance.new("TextButton")
        Button.Size = UDim2.new(1, 0, 1, 0)
        Button.BackgroundTransparency = 1
        Button.Text = ""
        Button.Parent = TabButton
        
        Button.MouseButton1Click:Connect(function()
            for _, t in ipairs(Tabs) do
                t.Page.Visible = t == tab
                t.Indicator.Visible = t == tab
                t.Icon.TextColor3 = t == tab and COLORS.Text or COLORS.TextDark
            end
        end)
        
        -- Select first tab
        if #Tabs == 1 then
            tab.Page.Visible = true
            tab.Indicator.Visible = true
            tab.Icon.TextColor3 = COLORS.Text
        end
        
        -- Create sections
        function Tab:CreateSection(name)
            return CreateSection(name, Page)
        end
        
        return Tab
    end

    return Window
end

return Library
