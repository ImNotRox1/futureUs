local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- Clean up previous UIs
local function DestroyUI()
    for _, gui in pairs(CoreGui:GetChildren()) do
        if gui.Name == "MinimalUI" then
            gui:Destroy()
        end
    end
end

DestroyUI()

-- Colors
local COLORS = {
    Background = Color3.fromRGB(18, 18, 24),
    Secondary = Color3.fromRGB(22, 22, 28),
    Accent = Color3.fromRGB(85, 100, 240),
    Text = Color3.fromRGB(235, 235, 235),
    TextDark = Color3.fromRGB(160, 160, 160),
    Hover = Color3.fromRGB(28, 28, 34),
    TabBackground = Color3.fromRGB(15, 15, 20),
    TabHover = Color3.fromRGB(25, 25, 30),
    TabSelected = Color3.fromRGB(85, 100, 240)
}

-- Theme definitions
local THEMES = {
    Dark = {
        Background = Color3.fromRGB(18, 18, 24),
        Secondary = Color3.fromRGB(22, 22, 30),
        Accent = Color3.fromRGB(85, 100, 240),
        Text = Color3.fromRGB(240, 240, 240),
        TextDark = Color3.fromRGB(160, 160, 160),
        TabBackground = Color3.fromRGB(15, 15, 20)
    },
    Light = {
        Background = Color3.fromRGB(240, 240, 245),
        Secondary = Color3.fromRGB(235, 235, 240),
        Accent = Color3.fromRGB(85, 100, 240),
        Text = Color3.fromRGB(20, 20, 20),
        TextDark = Color3.fromRGB(80, 80, 80),
        TabBackground = Color3.fromRGB(230, 230, 235)
    }
}

-- Function to update UI theme
local function updateTheme(themeName)
    local theme = THEMES[themeName]
    if not theme then return end
    
    -- Update all UI elements with new theme
    for _, obj in pairs(Main:GetDescendants()) do
        if obj:IsA("Frame") then
            if obj.BackgroundColor3 == COLORS.Background then
                TweenService:Create(obj, TweenInfo.new(0.2), {
                    BackgroundColor3 = theme.Background
                }):Play()
            elseif obj.BackgroundColor3 == COLORS.Secondary then
                TweenService:Create(obj, TweenInfo.new(0.2), {
                    BackgroundColor3 = theme.Secondary
                }):Play()
            end
        elseif obj:IsA("TextLabel") or obj:IsA("TextButton") then
            if obj.TextColor3 == COLORS.Text then
                TweenService:Create(obj, TweenInfo.new(0.2), {
                    TextColor3 = theme.Text
                }):Play()
            elseif obj.TextColor3 == COLORS.TextDark then
                TweenService:Create(obj, TweenInfo.new(0.2), {
                    TextColor3 = theme.TextDark
                }):Play()
            end
        end
    end
    
    -- Update COLORS table
    for key, value in pairs(theme) do
        COLORS[key] = value
    end
end

-- Add spacing constants
local SPACING = {
    TabPadding = 8,      -- Space between tabs
    ContentPadding = 6,   -- Space between content elements
    SidebarWidth = 46,   -- Width of sidebar
    TopBarHeight = 36    -- Height of top bar
}

-- Create ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MinimalUI"
ScreenGui.ResetOnSpawn = false

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
Main.Size = UDim2.new(0, 450, 0, 300)
Main.Position = UDim2.new(0.5, -225, 0.5, -150)
Main.BackgroundColor3 = COLORS.Background
Main.BorderSizePixel = 0
Main.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = Main

-- Top Bar
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 36)
TopBar.BackgroundColor3 = COLORS.Secondary
TopBar.BorderSizePixel = 0
TopBar.Parent = Main

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 8)
TopCorner.Parent = TopBar

-- Title (adjusted position)
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, -70, 1, 0)  -- Reduced width
Title.Position = UDim2.new(0, 60, 0, 0)  -- Moved right to avoid tabs
Title.BackgroundTransparency = 1
Title.Text = "M00N TESTING"
Title.TextColor3 = COLORS.Text
Title.TextSize = 15
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "Close"
CloseButton.Size = UDim2.new(0, 24, 0, 24)
CloseButton.Position = UDim2.new(1, -32, 0.5, -12)
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
CloseButton.BackgroundTransparency = 1
CloseButton.Text = "×"
CloseButton.TextColor3 = COLORS.Text
CloseButton.TextSize = 20
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Parent = TopBar

-- Content Area
local Content = Instance.new("Frame")
Content.Name = "Content"
Content.Size = UDim2.new(1, -(SPACING.SidebarWidth + 20), 1, -(SPACING.TopBarHeight + 10))
Content.Position = UDim2.new(0, SPACING.SidebarWidth + 10, 0, SPACING.TopBarHeight + 5)
Content.BackgroundTransparency = 1
Content.Parent = Main

local ContentList = Instance.new("UIListLayout")
ContentList.Padding = UDim.new(0, SPACING.ContentPadding)
ContentList.Parent = Content

-- Add padding around content
local ContentPadding = Instance.new("UIPadding")
ContentPadding.PaddingLeft = UDim.new(0, 5)
ContentPadding.PaddingRight = UDim.new(0, 5)
ContentPadding.Parent = Content

-- Side Tab Bar
local TabBar = Instance.new("Frame")
TabBar.Name = "TabBar"
TabBar.Size = UDim2.new(0, 45, 1, 0)
TabBar.Position = UDim2.new(0, 0, 0, 0)
TabBar.BackgroundColor3 = COLORS.TabBackground
TabBar.BorderSizePixel = 0
TabBar.Parent = Main

local TabCorner = Instance.new("UICorner")
TabCorner.CornerRadius = UDim.new(0, 8)
TabCorner.Parent = TabBar

-- Tab container
local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(1, 0, 1, -20)
TabContainer.Position = UDim2.new(0, 0, 0, 10)
TabContainer.BackgroundTransparency = 1
TabContainer.Parent = TabBar

local TabList = Instance.new("UIListLayout")
TabList.FillDirection = Enum.FillDirection.Vertical
TabList.Padding = UDim.new(0, 8)
TabList.HorizontalAlignment = Enum.HorizontalAlignment.Center
TabList.Parent = TabContainer

-- Content container for pages
local PageContainer = Instance.new("Frame")
PageContainer.Name = "Pages"
PageContainer.Size = UDim2.new(1, -60, 1, -50)
PageContainer.Position = UDim2.new(0, 55, 0, 45)
PageContainer.BackgroundTransparency = 1
PageContainer.Parent = Main

-- Store all tabs
local Tabs = {}

-- Function to create labels
local function CreateLabel(text, parent)
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, 0, 0, 24)
    Label.BackgroundTransparency = 1
    Label.Text = "    " .. text
    Label.TextColor3 = COLORS.Accent
    Label.TextSize = 13
    Label.Font = Enum.Font.GothamBold
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.LayoutOrder = -1  -- Make labels appear where they're created
    Label.Parent = parent
    
    local Padding = Instance.new("UIPadding")
    Padding.PaddingTop = UDim.new(0, 6)
    Padding.Parent = Label
    
    return Label
end

-- Function to create sections
local function CreateSection(name, parent)
    local Section = Instance.new("Frame")
    Section.Name = name
    Section.Size = UDim2.new(1, 0, 0, 36)
    Section.BackgroundColor3 = COLORS.Secondary
    Section.BorderSizePixel = 0
    Section.Parent = parent
    
    local SectionCorner = Instance.new("UICorner")
    SectionCorner.CornerRadius = UDim.new(0, 6)
    SectionCorner.Parent = Section
    
    local SectionTitle = Instance.new("TextLabel")
    SectionTitle.Size = UDim2.new(1, -16, 0, 26)
    SectionTitle.Position = UDim2.new(0, 8, 0, 2)
    SectionTitle.BackgroundTransparency = 1
    SectionTitle.Text = name
    SectionTitle.TextColor3 = COLORS.TextDark
    SectionTitle.TextSize = 14
    SectionTitle.Font = Enum.Font.GothamBold
    SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
    SectionTitle.Parent = Section
    
    local SectionContent = Instance.new("Frame")
    SectionContent.Name = "Content"
    SectionContent.Size = UDim2.new(1, -16, 0, 0)
    SectionContent.Position = UDim2.new(0, 8, 0, 28)
    SectionContent.BackgroundTransparency = 1
    SectionContent.Parent = Section
    
    local ContentList = Instance.new("UIListLayout")
    ContentList.Padding = UDim.new(0, 5)
    ContentList.Parent = SectionContent
    
    -- Auto-adjust section size based on content
    ContentList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Section.Size = UDim2.new(1, 0, 0, ContentList.AbsoluteContentSize.Y + 35)
    end)
    
    local SectionFunctions = {
        CreateToggle = function(text, callback)
            callback = callback or function() end
            local enabled = false
            
            local Toggle = Instance.new("Frame")
            Toggle.Size = UDim2.new(1, 0, 0, 32)
            Toggle.BackgroundColor3 = COLORS.Secondary
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
            Switch.BackgroundColor3 = COLORS.Background
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
            
            Toggle.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    enabled = not enabled
                    
                    TweenService:Create(Switch, TweenInfo.new(0.2), {
                        BackgroundColor3 = enabled and COLORS.Accent or COLORS.Background
                    }):Play()
                    
                    TweenService:Create(Indicator, TweenInfo.new(0.2), {
                        Position = enabled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
                    }):Play()
                    
                    callback(enabled)
                end
            end)
        end,
        
        CreateButton = function(text, callback)
            local Button = Instance.new("TextButton")
            Button.Size = UDim2.new(1, 0, 0, 32)
            Button.BackgroundColor3 = COLORS.Background
            Button.BorderSizePixel = 0
            Button.Text = text
            Button.TextColor3 = COLORS.Text
            Button.TextSize = 14
            Button.Font = Enum.Font.Gotham
            Button.Parent = SectionContent
            
            local ButtonCorner = Instance.new("UICorner")
            ButtonCorner.CornerRadius = UDim.new(0, 4)
            ButtonCorner.Parent = Button
            
            Button.MouseButton1Click:Connect(callback)
        end,
        
        CreateSlider = function(text, min, max, default, callback)
            callback = callback or function() end
            min = min or 0
            max = max or 100
            default = math.clamp(default or min, min, max)
            
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
            
            local Value = Instance.new("TextLabel")
            Value.Size = UDim2.new(0, 50, 0, 30)
            Value.Position = UDim2.new(1, -60, 0, 0)
            Value.BackgroundTransparency = 1
            Value.Text = tostring(default)
            Value.TextColor3 = COLORS.TextDark
            Value.TextSize = 14
            Value.Font = Enum.Font.Gotham
            Value.Parent = Slider
            
            local SliderBar = Instance.new("Frame")
            SliderBar.Size = UDim2.new(1, -30, 0, 4)
            SliderBar.Position = UDim2.new(0, 15, 0, 35)
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
            
            local SliderButton = Instance.new("TextButton")
            SliderButton.Size = UDim2.new(1, 0, 1, 0)
            SliderButton.BackgroundTransparency = 1
            SliderButton.Text = ""
            SliderButton.Parent = SliderBar
            
            local function update(input)
                local pos = UDim2.new(math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1), 0, 1, 0)
                SliderFill.Size = pos
                
                local value = math.floor(min + ((max - min) * pos.X.Scale))
                Value.Text = tostring(value)
                callback(value)
            end
            
            SliderButton.MouseButton1Down:Connect(function()
                local connection
                connection = UserInputService.InputChanged:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseMovement then
                        update(input)
                    end
                end)
                
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        connection:Disconnect()
                    end
                end)
            end)
            
            -- Hover effect
            Slider.MouseEnter:Connect(function()
                TweenService:Create(Slider, TweenInfo.new(0.2), {
                    BackgroundColor3 = COLORS.Secondary
                }):Play()
            end)
            
            Slider.MouseLeave:Connect(function()
                TweenService:Create(Slider, TweenInfo.new(0.2), {
                    BackgroundColor3 = COLORS.Background
                }):Play()
            end)
            
            return {
                SetValue = function(value)
                    value = math.clamp(value, min, max)
                    Value.Text = tostring(value)
                    SliderFill.Size = UDim2.new((value - min)/(max - min), 0, 1, 0)
                    callback(value)
                end,
                GetValue = function()
                    return tonumber(Value.Text)
                end
            }
        end,
        
        CreateBind = function(text, default, callback)
            callback = callback or function() end
            default = default or "None"
            
            local Bind = Instance.new("Frame")
            Bind.Size = UDim2.new(1, 0, 0, 32)
            Bind.BackgroundColor3 = COLORS.Background
            Bind.BorderSizePixel = 0
            Bind.Parent = SectionContent
            
            local BindCorner = Instance.new("UICorner")
            BindCorner.CornerRadius = UDim.new(0, 6)
            BindCorner.Parent = Bind
            
            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, -50, 1, 0)
            Label.Position = UDim2.new(0, 15, 0, 0)
            Label.BackgroundTransparency = 1
            Label.Text = text
            Label.TextColor3 = COLORS.Text
            Label.TextSize = 14
            Label.Font = Enum.Font.Gotham
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = Bind
            
            local KeyLabel = Instance.new("TextLabel")
            KeyLabel.Size = UDim2.new(0, 80, 0, 24)
            KeyLabel.Position = UDim2.new(1, -90, 0.5, -12)
            KeyLabel.BackgroundColor3 = COLORS.Secondary
            KeyLabel.BorderSizePixel = 0
            KeyLabel.Text = default
            KeyLabel.TextColor3 = COLORS.TextDark
            KeyLabel.TextSize = 12
            KeyLabel.Font = Enum.Font.Gotham
            KeyLabel.Parent = Bind
            
            local KeyCorner = Instance.new("UICorner")
            KeyCorner.CornerRadius = UDim.new(0, 4)
            KeyCorner.Parent = KeyLabel
            
            local BindButton = Instance.new("TextButton")
            BindButton.Size = UDim2.new(1, 0, 1, 0)
            BindButton.BackgroundTransparency = 1
            BindButton.Text = ""
            BindButton.Parent = Bind
            
            local binding = false
            local currentKey = default
            
            BindButton.MouseButton1Click:Connect(function()
                if binding then return end
                
                binding = true
                KeyLabel.Text = "..."
                KeyLabel.TextColor3 = COLORS.Accent
                
                local connection
                connection = UserInputService.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.Keyboard then
                        local keyName = input.KeyCode.Name
                        currentKey = keyName
                        KeyLabel.Text = keyName
                        KeyLabel.TextColor3 = COLORS.TextDark
                        binding = false
                        connection:Disconnect()
                        callback(input.KeyCode)
                    end
                end)
            end)
            
            -- Listen for key press
            UserInputService.InputBegan:Connect(function(input)
                if not binding and input.UserInputType == Enum.UserInputType.Keyboard then
                    if input.KeyCode.Name == currentKey then
                        callback(input.KeyCode)
                    end
                end
            end)
            
            -- Hover effect
            Bind.MouseEnter:Connect(function()
                TweenService:Create(Bind, TweenInfo.new(0.2), {
                    BackgroundColor3 = COLORS.Secondary
                }):Play()
            end)
            
            Bind.MouseLeave:Connect(function()
                TweenService:Create(Bind, TweenInfo.new(0.2), {
                    BackgroundColor3 = COLORS.Background
                }):Play()
            end)
            
            return {
                SetBind = function(key)
                    currentKey = key
                    KeyLabel.Text = key
                end,
                GetBind = function()
                    return currentKey
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

-- Function to create tabs
local function CreateTab(name, iconId)
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
    Page.Size = UDim2.new(1, -10, 1, -10)  -- Adjusted size
    Page.Position = UDim2.new(0, 5, 0, 5)   -- Added padding
    Page.BackgroundTransparency = 1
    Page.BorderSizePixel = 0
    Page.ScrollBarThickness = 2
    Page.ScrollBarImageColor3 = COLORS.Accent
    Page.CanvasSize = UDim2.new(0, 0, 0, 0)
    Page.ClipsDescendants = false  -- Allow dropdowns to show
    Page.Parent = PageHolder
    
    local PageList = Instance.new("UIListLayout")
    PageList.Padding = UDim.new(0, 8)  -- Increased padding
    PageList.HorizontalAlignment = Enum.HorizontalAlignment.Center
    PageList.Parent = Page

    -- Auto-adjust canvas size
    PageList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Page.CanvasSize = UDim2.new(0, 0, 0, PageList.AbsoluteContentSize.Y + 10)
    end)

    -- Add padding to the page
    local PagePadding = Instance.new("UIPadding")
    PagePadding.PaddingLeft = UDim.new(0, 5)
    PagePadding.PaddingRight = UDim.new(0, 5)
    PagePadding.Parent = Page

    -- Create tab button
    local TabButton = Instance.new("TextButton")
    TabButton.Size = UDim2.new(0, 35, 0, 35)
    TabButton.BackgroundColor3 = COLORS.TabBackground
    TabButton.BorderSizePixel = 0
    TabButton.Text = ""
    TabButton.Parent = TabContainer
    
    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 6)
    TabCorner.Parent = TabButton
    
    -- Icon
    local Icon = Instance.new("ImageLabel")
    Icon.Size = UDim2.new(0, 18, 0, 18)
    Icon.Position = UDim2.new(0.5, -9, 0.5, -9)
    Icon.BackgroundTransparency = 1
    Icon.Image = iconId
    Icon.ImageColor3 = COLORS.TextDark
    Icon.Parent = TabButton
    
    -- Selection indicator
    local SelectionIndicator = Instance.new("Frame")
    SelectionIndicator.Size = UDim2.new(0, 2, 0.7, 0)
    SelectionIndicator.Position = UDim2.new(0, 0, 0.15, 0)
    SelectionIndicator.BackgroundColor3 = COLORS.Accent
    SelectionIndicator.BorderSizePixel = 0
    SelectionIndicator.BackgroundTransparency = 1
    SelectionIndicator.Parent = TabButton
    
    -- Store tab data
    local tab = {
        Button = TabButton,
        Page = PageHolder,
        Icon = Icon,
        Indicator = SelectionIndicator
    }
    table.insert(Tabs, tab)
    
    -- Tab switching logic
    TabButton.MouseButton1Click:Connect(function()
        for _, t in pairs(Tabs) do
            t.Page.Visible = false
            t.Button.BackgroundColor3 = COLORS.TabBackground
            t.Indicator.BackgroundTransparency = 1
            t.Icon.ImageColor3 = COLORS.TextDark
        end
        
        PageHolder.Visible = true
        TabButton.BackgroundColor3 = COLORS.TabSelected
        SelectionIndicator.BackgroundTransparency = 0
        Icon.ImageColor3 = COLORS.Text
    end)
    
    -- Show first tab by default
    if #Tabs == 1 then
        PageHolder.Visible = true
        TabButton.BackgroundColor3 = COLORS.TabSelected
        SelectionIndicator.BackgroundTransparency = 0
        Icon.ImageColor3 = COLORS.Text
    end
    
    return {
        CreateSection = function(name)
            return CreateSection(name, Page)
        end
    }
end

-- Function to create buttons
local function CreateButton(text, callback)
    callback = callback or function() end
    
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, 0, 0, 32)
    Button.BackgroundColor3 = COLORS.Secondary
    Button.BorderSizePixel = 0
    Button.Text = text
    Button.TextColor3 = COLORS.Text
    Button.TextSize = 14
    Button.Font = Enum.Font.Gotham
    Button.Parent = Content
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 6)
    ButtonCorner.Parent = Button
    
    Button.MouseEnter:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.2), {
            BackgroundColor3 = COLORS.Hover
        }):Play()
    end)
    
    Button.MouseLeave:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.2), {
            BackgroundColor3 = COLORS.Secondary
        }):Play()
    end)
    
    Button.MouseButton1Click:Connect(callback)
end

-- Function to create toggles
local function CreateToggle(text, callback)
    callback = callback or function() end
    local enabled = false
    
    local Toggle = Instance.new("Frame")
    Toggle.Size = UDim2.new(1, 0, 0, 32)
    Toggle.BackgroundColor3 = COLORS.Secondary
    Toggle.BorderSizePixel = 0
    Toggle.Parent = Content
    
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
    Switch.BackgroundColor3 = COLORS.Background
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
    
    Toggle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            enabled = not enabled
            
            TweenService:Create(Switch, TweenInfo.new(0.2), {
                BackgroundColor3 = enabled and COLORS.Accent or COLORS.Background
            }):Play()
            
            TweenService:Create(Indicator, TweenInfo.new(0.2), {
                Position = enabled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
            }):Play()
            
            callback(enabled)
        end
    end)
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

-- Close button functionality
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

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)
