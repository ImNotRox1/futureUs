local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local Library = {
    Theme = {
        Background = Color3.fromRGB(20, 20, 25),
        Accent = Color3.fromRGB(96, 110, 255),
        AccentDark = Color3.fromRGB(76, 90, 235),
        Secondary = Color3.fromRGB(25, 25, 30),
        Text = Color3.fromRGB(240, 240, 240),
        TextDark = Color3.fromRGB(180, 180, 180),
        InputBackground = Color3.fromRGB(30, 30, 35),
        Divider = Color3.fromRGB(35, 35, 40),
        Hover = Color3.fromRGB(40, 40, 45)
    },
    Flags = {},
    ToggleKey = Enum.KeyCode.RightShift,
    Windows = {},
    Opened = true
}

local function Create(instanceType)
    return function(properties)
        local instance = Instance.new(instanceType)
        for property, value in pairs(properties) do
            instance[property] = value
        end
        return instance
    end
end

local function AddRippleEffect(button, rippleColor)
    rippleColor = rippleColor or Color3.fromRGB(255, 255, 255)
    
    local ripple = Create "Frame" {
        Name = "Ripple",
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = rippleColor,
        BackgroundTransparency = 0.8,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(0, 0, 0, 0),
        Parent = button
    }
    
    Create "UICorner" {
        CornerRadius = UDim.new(1, 0),
        Parent = ripple
    }
    
    local targetSize = UDim2.new(1.5, 0, 1.5, 0)
    local fadeTime = 0.5
    
    TweenService:Create(ripple, TweenInfo.new(fadeTime), {
        Size = targetSize,
        BackgroundTransparency = 1
    }):Play()
    
    game:GetService("Debris"):AddItem(ripple, fadeTime)
end

local function CreateStroke(parent, color, thickness)
    return Create "UIStroke" {
        Color = color or Library.Theme.Accent,
        Thickness = thickness or 1,
        Parent = parent
    }
end

function Library:CleanupPreviousInstances()
    -- Check all possible GUI locations and destroy previous instances
    local function cleanFromParent(parent)
        if parent then
            -- Destroy any GUI with our name
            for _, gui in ipairs(parent:GetChildren()) do
                if gui:IsA("ScreenGui") and gui.Name == "MacUI" then
                    pcall(function() 
                        gui:Destroy()
                    end)
                end
            end
        end
    end

    -- Try to clean from all possible locations
    cleanFromParent(game:GetService("CoreGui"))
    cleanFromParent(gethui and gethui() or nil)
    
    -- Clean from PlayerGui
    local player = game:GetService("Players").LocalPlayer
    if player then
        cleanFromParent(player:FindFirstChild("PlayerGui"))
    end
    
    -- Clean from current syn.protect_gui container if it exists
    if syn and syn.protect_gui then
        local protected = syn.protect_gui.container
        if protected then
            cleanFromParent(protected)
        end
    end
    
    -- Clear the windows table
    table.clear(self.Windows)
end

function Library:CreateWindow(title)
    self:CleanupPreviousInstances()
    
    local window = {}
    
    local ScreenGui = Create "ScreenGui" {
        Name = "MacUI",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    }
    
    -- Protection and parenting logic
    if syn then
        syn.protect_gui(ScreenGui)
        ScreenGui.Parent = game.CoreGui
    elseif gethui then
        ScreenGui.Parent = gethui()
    else
        ScreenGui.Parent = CoreGui
    end
    
    -- Main window frame
    local MainFrame = Create "Frame" {
        Name = "MainFrame",
        Size = UDim2.new(0, 600, 0, 400),
        Position = UDim2.new(0.5, -300, 0.5, -200),
        BackgroundColor3 = Library.Theme.Primary,
        BorderSizePixel = 0,
        Parent = ScreenGui
    }
    
    Create "UICorner" {
        CornerRadius = UDim.new(0, 8),
        Parent = MainFrame
    }
    
    -- Window shadow
    local Shadow = Create "ImageLabel" {
        Name = "Shadow",
        Size = UDim2.new(1, 47, 1, 47),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Image = "rbxassetid://6015897843",
        ImageColor3 = Color3.new(0, 0, 0),
        ImageTransparency = 0.5,
        Parent = MainFrame
    }
    
    -- Title bar
    local TitleBar = Create "Frame" {
        Name = "TitleBar",
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = Library.Theme.Secondary,
        BorderSizePixel = 0,
        Parent = MainFrame
    }
    
    Create "UICorner" {
        CornerRadius = UDim.new(0, 8),
        Parent = TitleBar
    }
    
    -- Title text
    local TitleText = Create "TextLabel" {
        Name = "Title",
        Size = UDim2.new(1, -20, 1, 0),
        Position = UDim2.new(0, 15, 0, 0),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = Library.Theme.Text,
        TextSize = 16,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = TitleBar
    }
    
    -- Sidebar
    local Sidebar = Create "Frame" {
        Name = "Sidebar",
        Size = UDim2.new(0, 150, 1, -30),
        Position = UDim2.new(0, 0, 0, 30),
        BackgroundColor3 = Library.Theme.Secondary,
        BorderSizePixel = 0,
        Parent = MainFrame
    }
    
    -- Tab container
    local TabContainer = Create "ScrollingFrame" {
        Name = "TabContainer",
        Size = UDim2.new(1, -20, 1, -20),
        Position = UDim2.new(0, 10, 0, 10),
        BackgroundTransparency = 1,
        ScrollBarThickness = 0,
        ScrollingEnabled = true,
        Parent = Sidebar
    }
    
    local TabListLayout = Create "UIListLayout" {
        Padding = UDim.new(0, 5),
        Parent = TabContainer
    }
    
    -- Content container
    local ContentContainer = Create "Frame" {
        Name = "ContentContainer",
        Size = UDim2.new(1, -170, 1, -50),
        Position = UDim2.new(0, 160, 0, 40),
        BackgroundColor3 = Library.Theme.Secondary,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Parent = MainFrame
    }
    
    Create "UICorner" {
        CornerRadius = UDim.new(0, 10),
        Parent = ContentContainer
    }

    -- Make window draggable with smooth dragging
    local dragging, dragInput, dragStart, startPos
    
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            TweenService:Create(MainFrame, TweenInfo.new(0.16, Enum.EasingStyle.Quad), {
                Position = UDim2.new(
                    startPos.X.Scale,
                    startPos.X.Offset + delta.X,
                    startPos.Y.Scale,
                    startPos.Y.Offset + delta.Y
                )
            }):Play()
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    function window:CreateTab(name)
        local tab = {}
        
        local TabButton = Create "TextButton" {
            Name = name,
            Size = UDim2.new(1, -20, 0, 32),
            BackgroundColor3 = Library.Theme.InputBackground,
            BackgroundTransparency = 0.9,
            Text = name,
            TextColor3 = Library.Theme.TextDark,
            TextSize = 14,
            Font = Enum.Font.GothamMedium,
            Parent = TabContainer
        }
        
        Create "UICorner" {
            CornerRadius = UDim.new(0, 6),
            Parent = TabButton
        }
        
        local TabPage = Create "ScrollingFrame" {
            Name = name.."Page",
            Size = UDim2.new(1, -20, 1, -20),
            Position = UDim2.new(0, 10, 0, 10),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ScrollBarThickness = 2,
            ScrollBarImageColor3 = Library.Theme.Accent,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            Visible = false,
            Parent = ContentContainer
        }
        
        local PageLayout = Create "UIListLayout" {
            Padding = UDim.new(0, 6),
            Parent = TabPage
        }

        -- Make first tab visible by default
        if #TabContainer:GetChildren() == 1 then
            TabPage.Visible = true
            TabButton.BackgroundTransparency = 0
            TabButton.TextColor3 = Library.Theme.Text
        end
        
        TabButton.MouseButton1Click:Connect(function()
            -- Hide all other tab pages
            for _, v in pairs(ContentContainer:GetChildren()) do
                if v:IsA("ScrollingFrame") then
                    v.Visible = false
                end
            end
            TabPage.Visible = true
            
            -- Reset all tab buttons
            for _, v in pairs(TabContainer:GetChildren()) do
                if v:IsA("TextButton") then
                    TweenService:Create(v, TweenInfo.new(0.2), {
                        BackgroundTransparency = 0.9,
                        TextColor3 = Library.Theme.TextDark
                    }):Play()
                end
            end
            
            -- Highlight active tab
            TweenService:Create(TabButton, TweenInfo.new(0.2), {
                BackgroundTransparency = 0,
                TextColor3 = Library.Theme.Text
            }):Play()
        end)
        
        -- Update canvas size
        PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabPage.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 10)
        end)
        
        function tab:CreateButton(text, callback)
            callback = callback or function() end
            
            local Button = Create "TextButton" {
                Name = text,
                Size = UDim2.new(1, 0, 0, 40),
                BackgroundColor3 = Library.Theme.InputBackground,
                BorderSizePixel = 0,
                Text = "",
                AutoButtonColor = false,
                Parent = TabPage
            }
            
            Create "UICorner" {
                CornerRadius = UDim.new(0, 8),
                Parent = Button
            }
            
            local ButtonLabel = Create "TextLabel" {
                Name = "Label",
                Size = UDim2.new(1, -20, 1, 0),
                Position = UDim2.new(0, 15, 0, 0),
                BackgroundTransparency = 1,
                Text = text,
                TextColor3 = Library.Theme.Text,
                TextSize = 14,
                Font = Enum.Font.GothamMedium,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = Button
            }
            
            local ButtonIcon = Create "ImageLabel" {
                Name = "Icon",
                Size = UDim2.new(0, 20, 0, 20),
                Position = UDim2.new(1, -35, 0.5, -10),
                BackgroundTransparency = 1,
                Image = "rbxassetid://14299284116",
                ImageColor3 = Library.Theme.TextDark,
                Parent = Button
            }
            
            Button.MouseEnter:Connect(function()
                TweenService:Create(Button, TweenInfo.new(0.2), {
                    BackgroundColor3 = Library.Theme.Accent
                }):Play()
                TweenService:Create(ButtonIcon, TweenInfo.new(0.2), {
                    ImageColor3 = Library.Theme.Text
                }):Play()
            end)
            
            Button.MouseLeave:Connect(function()
                TweenService:Create(Button, TweenInfo.new(0.2), {
                    BackgroundColor3 = Library.Theme.InputBackground
                }):Play()
                TweenService:Create(ButtonIcon, TweenInfo.new(0.2), {
                    ImageColor3 = Library.Theme.TextDark
                }):Play()
            end)
            
            Button.MouseButton1Click:Connect(function()
                callback()
                
                -- Click effect
                TweenService:Create(Button, TweenInfo.new(0.1), {
                    Size = UDim2.new(1, 0, 0, 38)
                }):Play()
                wait(0.1)
                TweenService:Create(Button, TweenInfo.new(0.1), {
                    Size = UDim2.new(1, 0, 0, 40)
                }):Play()
            end)
        end
        
        function tab:CreateToggle(text, default, callback)
            callback = callback or function() end
            default = default or false
            
            local Toggle = Create "Frame" {
                Name = text,
                Size = UDim2.new(1, 0, 0, 40),
                BackgroundColor3 = Library.Theme.InputBackground,
                BorderSizePixel = 0,
                Parent = TabPage
            }
            
            Create "UICorner" {
                CornerRadius = UDim.new(0, 8),
                Parent = Toggle
            }
            
            local ToggleLabel = Create "TextLabel" {
                Name = "Label",
                Size = UDim2.new(1, -70, 1, 0),
                Position = UDim2.new(0, 15, 0, 0),
                BackgroundTransparency = 1,
                Text = text,
                TextColor3 = Library.Theme.Text,
                TextSize = 14,
                Font = Enum.Font.GothamMedium,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = Toggle
            }
            
            local ToggleButton = Create "Frame" {
                Name = "Button",
                Size = UDim2.new(0, 40, 0, 20),
                Position = UDim2.new(1, -55, 0.5, -10),
                BackgroundColor3 = default and Library.Theme.Accent or Library.Theme.InputBackground,
                BorderSizePixel = 0,
                Parent = Toggle
            }
            
            Create "UICorner" {
                CornerRadius = UDim.new(1, 0),
                Parent = ToggleButton
            }
            
            local ToggleCircle = Create "Frame" {
                Name = "Circle",
                Size = UDim2.new(0, 16, 0, 16),
                Position = UDim2.new(0, default and 22 or 2, 0.5, -8),
                BackgroundColor3 = Library.Theme.Text,
                BorderSizePixel = 0,
                Parent = ToggleButton
            }
            
            Create "UICorner" {
                CornerRadius = UDim.new(1, 0),
                Parent = ToggleCircle
            }
            
            local toggled = default
            local debounce = false
            
            local function toggle()
                if debounce then return end
                debounce = true
                
                toggled = not toggled
                
                -- Animate the toggle
                TweenService:Create(ToggleButton, TweenInfo.new(0.2), {
                    BackgroundColor3 = toggled and Library.Theme.Accent or Library.Theme.InputBackground
                }):Play()
                
                TweenService:Create(ToggleCircle, TweenInfo.new(0.2), {
                    Position = UDim2.new(0, toggled and 22 or 2, 0.5, -8)
                }):Play()
                
                callback(toggled)
                
                task.wait(0.2)
                debounce = false
            end
            
            -- Click handlers
            Toggle.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    toggle()
                end
            end)
            
            -- Hover effects
            Toggle.MouseEnter:Connect(function()
                TweenService:Create(Toggle, TweenInfo.new(0.2), {
                    BackgroundColor3 = Library.Theme.Accent
                }):Play()
            end)
            
            Toggle.MouseLeave:Connect(function()
                TweenService:Create(Toggle, TweenInfo.new(0.2), {
                    BackgroundColor3 = Library.Theme.InputBackground
                }):Play()
            end)
            
            local toggleFuncs = {}
            
            function toggleFuncs:Set(value)
                if toggled ~= value then
                    toggle()
                end
            end
            
            function toggleFuncs:Get()
                return toggled
            end
            
            return toggleFuncs
        end
        
        function tab:CreateSection(name)
            local Section = Create "Frame" {
                Name = name,
                Size = UDim2.new(1, 0, 0, 35),
                BackgroundTransparency = 1,
                Parent = TabPage
            }
            
            local SectionLabel = Create "TextLabel" {
                Name = "Label",
                Size = UDim2.new(1, -10, 0, 25),
                Position = UDim2.new(0, 5, 0, 5),
                BackgroundTransparency = 1,
                Text = name,
                TextColor3 = Library.Theme.Accent,
                TextSize = 14,
                Font = Enum.Font.GothamBold,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = Section
            }
            
            local Divider = Create "Frame" {
                Name = "Divider",
                Size = UDim2.new(1, 0, 0, 1),
                Position = UDim2.new(0, 0, 1, -1),
                BackgroundColor3 = Library.Theme.Divider,
                BorderSizePixel = 0,
                Parent = Section
            }
            
            return Section
        end
        
        function tab:CreateDropdown(text, options, callback)
            callback = callback or function() end
            options = options or {}
            
            local Dropdown = Create "Frame" {
                Name = text,
                Size = UDim2.new(1, 0, 0, 40),
                BackgroundColor3 = Library.Theme.InputBackground,
                BorderSizePixel = 0,
                Parent = TabPage
            }
            
            Create "UICorner" {
                CornerRadius = UDim.new(0, 8),
                Parent = Dropdown
            }
            
            local DropdownLabel = Create "TextLabel" {
                Name = "Label",
                Size = UDim2.new(1, -40, 1, 0),
                Position = UDim2.new(0, 15, 0, 0),
                BackgroundTransparency = 1,
                Text = text,
                TextColor3 = Library.Theme.Text,
                TextSize = 14,
                Font = Enum.Font.GothamMedium,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = Dropdown
            }
            
            local DropdownButton = Create "TextButton" {
                Name = "Button",
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Text = "",
                Parent = Dropdown
            }
            
            local DropdownIcon = Create "ImageLabel" {
                Name = "Icon",
                Size = UDim2.new(0, 20, 0, 20),
                Position = UDim2.new(1, -30, 0.5, -10),
                BackgroundTransparency = 1,
                Image = "rbxassetid://6034818372",
                ImageColor3 = Library.Theme.TextDark,
                Parent = Dropdown
            }
            
            local DropdownContent = Create "Frame" {
                Name = "Content",
                Size = UDim2.new(1, 0, 0, 0),
                Position = UDim2.new(0, 0, 1, 5),
                BackgroundColor3 = Library.Theme.InputBackground,
                BorderSizePixel = 0,
                ClipsDescendants = true,
                Visible = false,
                Parent = Dropdown
            }
            
            Create "UICorner" {
                CornerRadius = UDim.new(0, 8),
                Parent = DropdownContent
            }
            
            local ContentLayout = Create "UIListLayout" {
                Parent = DropdownContent
            }
            
            local opened = false
            
            local function toggleDropdown()
                opened = not opened
                
                DropdownContent.Visible = true
                TweenService:Create(DropdownContent, TweenInfo.new(0.2), {
                    Size = UDim2.new(1, 0, 0, opened and (ContentLayout.AbsoluteContentSize.Y + 10) or 0)
                }):Play()
                
                TweenService:Create(DropdownIcon, TweenInfo.new(0.2), {
                    Rotation = opened and 180 or 0
                }):Play()
                
                if not opened then
                    task.delay(0.2, function()
                        DropdownContent.Visible = false
                    end)
                end
            end
            
            DropdownButton.MouseButton1Click:Connect(toggleDropdown)
            
            for _, option in ipairs(options) do
                local OptionButton = Create "TextButton" {
                    Name = option,
                    Size = UDim2.new(1, 0, 0, 30),
                    BackgroundTransparency = 1,
                    Text = option,
                    TextColor3 = Library.Theme.TextDark,
                    TextSize = 14,
                    Font = Enum.Font.GothamMedium,
                    Parent = DropdownContent
                }
                
                OptionButton.MouseEnter:Connect(function()
                    TweenService:Create(OptionButton, TweenInfo.new(0.2), {
                        TextColor3 = Library.Theme.Text
                    }):Play()
                end)
                
                OptionButton.MouseLeave:Connect(function()
                    TweenService:Create(OptionButton, TweenInfo.new(0.2), {
                        TextColor3 = Library.Theme.TextDark
                    }):Play()
                end)
                
                OptionButton.MouseButton1Click:Connect(function()
                    callback(option)
                    DropdownLabel.Text = text .. " - " .. option
                    toggleDropdown()
                end)
            end
        end
        
        function tab:CreateSlider(text, min, max, default, callback)
            callback = callback or function() end
            min = min or 0
            max = max or 100
            default = math.clamp(default or min, min, max)

            local Slider = Create "Frame" {
                Name = text,
                Size = UDim2.new(1, 0, 0, 50),
                BackgroundColor3 = Library.Theme.InputBackground,
                BorderSizePixel = 0,
                Parent = TabPage
            }

            Create "UICorner" {
                CornerRadius = UDim.new(0, 8),
                Parent = Slider
            }

            local SliderLabel = Create "TextLabel" {
                Name = "Label",
                Size = UDim2.new(1, -65, 0, 30),
                Position = UDim2.new(0, 15, 0, 0),
                BackgroundTransparency = 1,
                Text = text,
                TextColor3 = Library.Theme.Text,
                TextSize = 14,
                Font = Enum.Font.GothamMedium,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = Slider
            }

            local ValueLabel = Create "TextLabel" {
                Name = "Value",
                Size = UDim2.new(0, 50, 0, 30),
                Position = UDim2.new(1, -60, 0, 0),
                BackgroundTransparency = 1,
                Text = tostring(default),
                TextColor3 = Library.Theme.TextDark,
                TextSize = 14,
                Font = Enum.Font.GothamMedium,
                Parent = Slider
            }

            local SliderBar = Create "Frame" {
                Name = "Bar",
                Size = UDim2.new(1, -30, 0, 4),
                Position = UDim2.new(0, 15, 0, 35),
                BackgroundColor3 = Library.Theme.Secondary,
                BorderSizePixel = 0,
                Parent = Slider
            }

            Create "UICorner" {
                CornerRadius = UDim.new(1, 0),
                Parent = SliderBar
            }

            local SliderFill = Create "Frame" {
                Name = "Fill",
                Size = UDim2.new((default - min)/(max - min), 0, 1, 0),
                BackgroundColor3 = Library.Theme.Accent,
                BorderSizePixel = 0,
                Parent = SliderBar
            }

            Create "UICorner" {
                CornerRadius = UDim.new(1, 0),
                Parent = SliderFill
            }

            local SliderButton = Create "TextButton" {
                Name = "Button",
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Text = "",
                Parent = SliderBar
            }

            local dragging = false

            local function updateSlider(input)
                local relativePos = input.Position.X - SliderBar.AbsolutePosition.X
                local percentage = math.clamp(relativePos / SliderBar.AbsoluteSize.X, 0, 1)
                local value = math.floor(min + (max - min) * percentage)
                
                TweenService:Create(SliderFill, TweenInfo.new(0.1), {
                    Size = UDim2.new(percentage, 0, 1, 0)
                }):Play()
                
                ValueLabel.Text = tostring(value)
                callback(value)
            end

            SliderButton.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    updateSlider(input)
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    updateSlider(input)
                end
            end)

            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)

            -- Hover effect
            Slider.MouseEnter:Connect(function()
                TweenService:Create(Slider, TweenInfo.new(0.2), {
                    BackgroundColor3 = Library.Theme.Accent
                }):Play()
            end)

            Slider.MouseLeave:Connect(function()
                TweenService:Create(Slider, TweenInfo.new(0.2), {
                    BackgroundColor3 = Library.Theme.InputBackground
                }):Play()
            end)

            local sliderFuncs = {}

            function sliderFuncs:Set(value)
                value = math.clamp(value, min, max)
                local percentage = (value - min)/(max - min)
                TweenService:Create(SliderFill, TweenInfo.new(0.1), {
                    Size = UDim2.new(percentage, 0, 1, 0)
                }):Play()
                ValueLabel.Text = tostring(value)
                callback(value)
            end

            return sliderFuncs
        end
        
        function tab:CreateColorPicker(text, default, callback)
            callback = callback or function() end
            default = default or Color3.fromRGB(255, 255, 255)

            local ColorPicker = Create "Frame" {
                Name = text,
                Size = UDim2.new(1, 0, 0, 40),
                BackgroundColor3 = Library.Theme.InputBackground,
                BorderSizePixel = 0,
                Parent = TabPage
            }

            Create "UICorner" {
                CornerRadius = UDim.new(0, 8),
                Parent = ColorPicker
            }

            local ColorLabel = Create "TextLabel" {
                Name = "Label",
                Size = UDim2.new(1, -60, 1, 0),
                Position = UDim2.new(0, 15, 0, 0),
                BackgroundTransparency = 1,
                Text = text,
                TextColor3 = Library.Theme.Text,
                TextSize = 14,
                Font = Enum.Font.GothamMedium,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = ColorPicker
            }

            local ColorDisplay = Create "Frame" {
                Name = "Display",
                Size = UDim2.new(0, 30, 0, 30),
                Position = UDim2.new(1, -45, 0.5, -15),
                BackgroundColor3 = default,
                BorderSizePixel = 0,
                Parent = ColorPicker
            }

            Create "UICorner" {
                CornerRadius = UDim.new(0, 6),
                Parent = ColorDisplay
            }

            -- Add color picker UI and functionality here
            -- This is a basic version, you might want to add a full HSV color picker

            ColorDisplay.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    -- Open color picker window
                    print("Color picker clicked - Add your color picker UI here")
                end
            end)

            local colorFuncs = {}

            function colorFuncs:Set(color)
                ColorDisplay.BackgroundColor3 = color
                callback(color)
            end

            return colorFuncs
        end
        
        return tab
    end
    
    function window:Destroy()
        ScreenGui:Destroy()
        for i, w in pairs(Library.Windows) do
            if w == window then
                table.remove(Library.Windows, i)
                break
            end
        end
    end
    
    table.insert(Library.Windows, window)
    return window
end

function Library:DestroyAll()
    for _, window in pairs(self.Windows) do
        window:Destroy()
    end
    self.Windows = {}
end

return Library
