local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local Library = {
    Theme = {
        Background = Color3.fromRGB(32, 32, 32), -- Dark background
        Secondary = Color3.fromRGB(38, 38, 38), -- Slightly lighter
        Accent = Color3.fromRGB(0, 122, 255), -- macOS blue
        AccentDark = Color3.fromRGB(0, 102, 235),
        Text = Color3.fromRGB(255, 255, 255),
        TextDark = Color3.fromRGB(180, 180, 180),
        InputBackground = Color3.fromRGB(45, 45, 45),
        WindowButtons = {
            Close = Color3.fromRGB(255, 95, 87),
            Minimize = Color3.fromRGB(255, 189, 46),
            Maximize = Color3.fromRGB(39, 201, 63)
        }
    },
    Flags = {},
    ToggleKey = Enum.KeyCode.RightShift,
    Windows = {},
    UniqueId = "MacUI_" .. game:GetService("HttpService"):GenerateGUID(false)
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

local function AddBlur(frame)
    local blur = Create "BlurEffect" {
        Size = 10,
        Parent = frame
    }
    return blur
end

local function CreateStroke(parent)
    return Create "UIStroke" {
        Color = Library.Theme.Secondary,
        Thickness = 1.5,
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
        BackgroundColor3 = Library.Theme.Background,
        BorderSizePixel = 0,
        Parent = ScreenGui
    }
    
    Create "UICorner" {
        CornerRadius = UDim.new(0, 10),
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
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundColor3 = Library.Theme.Secondary,
        BorderSizePixel = 0,
        Parent = MainFrame
    }
    
    Create "UICorner" {
        CornerRadius = UDim.new(0, 10),
        Parent = TitleBar
    }
    
    -- Window buttons (traffic lights)
    local ButtonHolder = Create "Frame" {
        Name = "ButtonHolder",
        Size = UDim2.new(0, 60, 1, -16),
        Position = UDim2.new(0, 10, 0, 8),
        BackgroundTransparency = 1,
        Parent = TitleBar
    }
    
    -- Close button
    local CloseButton = Create "TextButton" {
        Name = "Close",
        Size = UDim2.new(0, 12, 0, 12),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = Library.Theme.WindowButtons.Close,
        Text = "",
        Parent = ButtonHolder
    }
    
    Create "UICorner" {
        CornerRadius = UDim.new(1, 0),
        Parent = CloseButton
    }
    
    -- Minimize button
    local MinimizeButton = Create "TextButton" {
        Name = "Minimize",
        Size = UDim2.new(0, 12, 0, 12),
        Position = UDim2.new(0, 24, 0, 0),
        BackgroundColor3 = Library.Theme.WindowButtons.Minimize,
        Text = "",
        Parent = ButtonHolder
    }
    
    Create "UICorner" {
        CornerRadius = UDim.new(1, 0),
        Parent = MinimizeButton
    }
    
    -- Maximize button
    local MaximizeButton = Create "TextButton" {
        Name = "Maximize",
        Size = UDim2.new(0, 12, 0, 12),
        Position = UDim2.new(0, 48, 0, 0),
        BackgroundColor3 = Library.Theme.WindowButtons.Maximize,
        Text = "",
        Parent = ButtonHolder
    }
    
    Create "UICorner" {
        CornerRadius = UDim.new(1, 0),
        Parent = MaximizeButton
    }
    
    -- Title text
    local TitleText = Create "TextLabel" {
        Name = "Title",
        Size = UDim2.new(1, -140, 1, 0),
        Position = UDim2.new(0.5, 0, 0, 0),
        AnchorPoint = Vector2.new(0.5, 0),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = Library.Theme.Text,
        TextSize = 13,
        Font = Enum.Font.SourceSansBold,
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
    
    -- Content area
    local ContentArea = Create "Frame" {
        Name = "ContentArea",
        Size = UDim2.new(1, -170, 1, -50),
        Position = UDim2.new(0, 160, 0, 40),
        BackgroundColor3 = Library.Theme.Secondary,
        BorderSizePixel = 0,
        Parent = MainFrame
    }
    
    Create "UICorner" {
        CornerRadius = UDim.new(0, 10),
        Parent = ContentArea
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
            Size = UDim2.new(0, 100, 1, 0),
            BackgroundColor3 = Library.Theme.InputBackground,
            BackgroundTransparency = 1,
            Text = name,
            TextColor3 = Library.Theme.TextDark,
            TextSize = 14,
            Font = Enum.Font.GothamMedium,
            Parent = TabContainer
        }
        
        local TabButtonHighlight = Create "Frame" {
            Name = "Highlight",
            Size = UDim2.new(1, 0, 0, 2),
            Position = UDim2.new(0, 0, 1, -2),
            BackgroundColor3 = Library.Theme.Accent,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Parent = TabButton
        }
        
        local TabContainer = Create "ScrollingFrame" {
            Name = name.."Container",
            Size = UDim2.new(1, -20, 1, -20),
            Position = UDim2.new(0, 10, 0, 10),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ScrollBarThickness = 2,
            ScrollBarImageColor3 = Library.Theme.Accent,
            Visible = false,
            Parent = ContentArea
        }
        
        local ContainerLayout = Create "UIListLayout" {
            Padding = UDim.new(0, 8),
            Parent = TabContainer
        }
        
        TabButton.MouseButton1Click:Connect(function()
            for _, v in pairs(ContentArea:GetChildren()) do
                if v:IsA("ScrollingFrame") then
                    v.Visible = false
                end
            end
            TabContainer.Visible = true
            
            for _, v in pairs(TabContainer:GetChildren()) do
                if v:IsA("TextButton") then
                    TweenService:Create(v, TweenInfo.new(0.2), {
                        TextColor3 = Library.Theme.TextDark
                    }):Play()
                    TweenService:Create(v.Highlight, TweenInfo.new(0.2), {
                        BackgroundTransparency = 1
                    }):Play()
                end
            end
            
            TweenService:Create(TabButton, TweenInfo.new(0.2), {
                TextColor3 = Library.Theme.Accent
            }):Play()
            TweenService:Create(TabButtonHighlight, TweenInfo.new(0.2), {
                BackgroundTransparency = 0
            }):Play()
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
                Parent = TabContainer
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
                Parent = TabContainer
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
