local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Library = {
    Theme = {
        Primary = Color3.fromRGB(30, 30, 35),
        Secondary = Color3.fromRGB(25, 25, 30),
        Accent = Color3.fromRGB(96, 130, 255),
        AccentDark = Color3.fromRGB(76, 110, 235),
        Text = Color3.fromRGB(240, 240, 240),
        TextDark = Color3.fromRGB(140, 140, 150),
        Background = Color3.fromRGB(20, 20, 25),
        InputBackground = Color3.fromRGB(35, 35, 40)
    },
    Flags = {},
    ToggleKey = Enum.KeyCode.RightShift,
    Windows = {}
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

function Library:CreateWindow(title)
    local window = {}
    
    local ScreenGui = Create "ScreenGui" {
        Name = "ModernUI",
        ResetOnSpawn = false
    }
    
    if syn then
        syn.protect_gui(ScreenGui)
        ScreenGui.Parent = game.CoreGui
    elseif gethui then
        ScreenGui.Parent = gethui()
    else
        ScreenGui.Parent = game:GetService("CoreGui")
    end
    
    -- Main container
    local MainFrame = Create "Frame" {
        Name = "MainFrame",
        Size = UDim2.new(0, 500, 0, 350),
        Position = UDim2.new(0.5, -250, 0.5, -175),
        BackgroundColor3 = Library.Theme.Primary,
        BorderSizePixel = 0,
        Parent = ScreenGui
    }
    
    Create "UICorner" {
        CornerRadius = UDim.new(0, 12),
        Parent = MainFrame
    }
    
    CreateStroke(MainFrame)
    
    -- Top bar with gradient
    local TopBar = Create "Frame" {
        Name = "TopBar",
        Size = UDim2.new(1, 0, 0, 50),
        BackgroundColor3 = Library.Theme.Secondary,
        BorderSizePixel = 0,
        Parent = MainFrame
    }
    
    Create "UICorner" {
        CornerRadius = UDim.new(0, 12),
        Parent = TopBar
    }
    
    local TopBarGradient = Create "UIGradient" {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 200, 200))
        }),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.95),
            NumberSequenceKeypoint.new(1, 0.97)
        }),
        Rotation = 45,
        Parent = TopBar
    }
    
    -- Title with icon
    local TitleContainer = Create "Frame" {
        Name = "TitleContainer",
        Size = UDim2.new(0, 200, 1, 0),
        BackgroundTransparency = 1,
        Parent = TopBar
    }
    
    local Icon = Create "ImageLabel" {
        Name = "Icon",
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(0, 15, 0.5, -15),
        BackgroundTransparency = 1,
        Image = "rbxassetid://14299284116",
        ImageColor3 = Library.Theme.Accent,
        Parent = TitleContainer
    }
    
    local TitleText = Create "TextLabel" {
        Name = "Title",
        Size = UDim2.new(0, 150, 1, 0),
        Position = UDim2.new(0, 55, 0, 0),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = Library.Theme.Text,
        TextSize = 18,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = TitleContainer
    }
    
    -- Navigation bar
    local NavBar = Create "Frame" {
        Name = "NavBar",
        Size = UDim2.new(1, -20, 0, 35),
        Position = UDim2.new(0, 10, 0, 60),
        BackgroundColor3 = Library.Theme.Secondary,
        BorderSizePixel = 0,
        Parent = MainFrame
    }
    
    Create "UICorner" {
        CornerRadius = UDim.new(0, 8),
        Parent = NavBar
    }
    
    local TabButtons = Create "Frame" {
        Name = "TabButtons",
        Size = UDim2.new(1, -20, 1, -10),
        Position = UDim2.new(0, 10, 0, 5),
        BackgroundTransparency = 1,
        Parent = NavBar
    }
    
    local TabButtonLayout = Create "UIListLayout" {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Left,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 5),
        Parent = TabButtons
    }
    
    -- Content container
    local ContentContainer = Create "Frame" {
        Name = "ContentContainer",
        Size = UDim2.new(1, -20, 1, -105),
        Position = UDim2.new(0, 10, 0, 105),
        BackgroundColor3 = Library.Theme.Secondary,
        BorderSizePixel = 0,
        Parent = MainFrame
    }
    
    Create "UICorner" {
        CornerRadius = UDim.new(0, 8),
        Parent = ContentContainer
    }
    
    -- Make window draggable with smooth dragging
    local dragging, dragInput, dragStart, startPos
    
    TopBar.InputBegan:Connect(function(input)
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
            Parent = TabButtons
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
            Parent = ContentContainer
        }
        
        local ContainerLayout = Create "UIListLayout" {
            Padding = UDim.new(0, 8),
            Parent = TabContainer
        }
        
        TabButton.MouseButton1Click:Connect(function()
            for _, v in pairs(ContentContainer:GetChildren()) do
                if v:IsA("ScrollingFrame") then
                    v.Visible = false
                end
            end
            TabContainer.Visible = true
            
            for _, v in pairs(TabButtons:GetChildren()) do
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
