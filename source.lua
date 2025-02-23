local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Library = {
    Theme = {
        Background = Color3.fromRGB(32, 32, 32),
        Sidebar = Color3.fromRGB(28, 28, 28),
        Content = Color3.fromRGB(36, 36, 36),
        TextColor = Color3.fromRGB(240, 240, 240),
        TextDark = Color3.fromRGB(150, 150, 150),
        Accent = Color3.fromRGB(0, 122, 255),
        InputBackground = Color3.fromRGB(45, 45, 45),
        WindowButtons = {
            Close = Color3.fromRGB(255, 95, 87),
            Minimize = Color3.fromRGB(255, 189, 46),
            Maximize = Color3.fromRGB(39, 201, 63)
        }
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

function Library:CreateWindow(title)
    local window = {}
    
    local ScreenGui = Create "ScreenGui" {
        Name = "MacUI",
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
    
    -- Main container with shadow
    local MainFrame = Create "Frame" {
        Name = "MainFrame",
        Size = UDim2.new(0, 300, 0, 400),
        Position = UDim2.new(0.5, -150, 0.5, -200),
        BackgroundColor3 = Library.Theme.Background,
        BorderSizePixel = 0,
        Parent = ScreenGui
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
    
    Create "UICorner" {
        CornerRadius = UDim.new(0, 8),
        Parent = MainFrame
    }
    
    -- Title bar
    local TitleBar = Create "Frame" {
        Name = "TitleBar",
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundColor3 = Library.Theme.Sidebar,
        BorderSizePixel = 0,
        Parent = MainFrame
    }
    
    Create "UICorner" {
        CornerRadius = UDim.new(0, 8),
        Parent = TitleBar
    }
    
    -- Window buttons (traffic lights)
    local ButtonHolder = Create "Frame" {
        Name = "ButtonHolder",
        Size = UDim2.new(0, 60, 1, -16),
        Position = UDim2.new(0, 8, 0, 8),
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
        TextColor3 = Library.Theme.TextColor,
        TextSize = 13,
        Font = Enum.Font.SFProDisplay,
        Parent = TitleBar
    }
    
    -- Content container
    local ContentFrame = Create "Frame" {
        Name = "Content",
        Size = UDim2.new(1, -16, 1, -46),
        Position = UDim2.new(0, 8, 0, 38),
        BackgroundColor3 = Library.Theme.Content,
        BorderSizePixel = 0,
        Parent = MainFrame
    }
    
    Create "UICorner" {
        CornerRadius = UDim.new(0, 8),
        Parent = ContentFrame
    }
    
    -- Sidebar
    local Sidebar = Create "Frame" {
        Name = "Sidebar",
        Size = UDim2.new(0, 100, 1, -16),
        Position = UDim2.new(0, 8, 0, 8),
        BackgroundColor3 = Library.Theme.Sidebar,
        BorderSizePixel = 0,
        Parent = ContentFrame
    }
    
    Create "UICorner" {
        CornerRadius = UDim.new(0, 6),
        Parent = Sidebar
    }
    
    local TabList = Create "ScrollingFrame" {
        Name = "TabList",
        Size = UDim2.new(1, -16, 1, -16),
        Position = UDim2.new(0, 8, 0, 8),
        BackgroundTransparency = 1,
        ScrollBarThickness = 0,
        ScrollingEnabled = true,
        Parent = Sidebar
    }
    
    local TabListLayout = Create "UIListLayout" {
        Padding = UDim.new(0, 4),
        Parent = TabList
    }
    
    -- Content area
    local TabContent = Create "Frame" {
        Name = "TabContent",
        Size = UDim2.new(1, -124, 1, -16),
        Position = UDim2.new(0, 116, 0, 8),
        BackgroundTransparency = 1,
        Parent = ContentFrame
    }
    
    -- Make window draggable
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
            TweenService:Create(MainFrame, TweenInfo.new(0.1), {
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
    
    -- Window buttons functionality
    CloseButton.MouseButton1Click:Connect(function()
        window:Destroy()
    end)
    
    MinimizeButton.MouseButton1Click:Connect(function()
        MainFrame.Visible = false
    end)
    
    -- Tab creation function
    function window:CreateTab(name)
        local tab = {}
        
        local TabButton = Create "TextButton" {
            Name = name,
            Size = UDim2.new(1, 0, 0, 28),
            BackgroundColor3 = Library.Theme.InputBackground,
            BackgroundTransparency = 1,
            Text = name,
            TextColor3 = Library.Theme.TextDark,
            TextSize = 13,
            Font = Enum.Font.SFProDisplay,
            Parent = TabList
        }
        
        local TabContainer = Create "ScrollingFrame" {
            Name = name.."Container",
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            ScrollBarThickness = 2,
            ScrollBarImageColor3 = Library.Theme.TextDark,
            Visible = false,
            Parent = TabContent
        }
        
        local ContainerLayout = Create "UIListLayout" {
            Padding = UDim.new(0, 6),
            Parent = TabContainer
        }
        
        TabButton.MouseButton1Click:Connect(function()
            for _, v in pairs(TabContent:GetChildren()) do
                if v:IsA("ScrollingFrame") then
                    v.Visible = false
                end
            end
            TabContainer.Visible = true
            
            for _, v in pairs(TabList:GetChildren()) do
                if v:IsA("TextButton") then
                    TweenService:Create(v, TweenInfo.new(0.2), {
                        TextColor3 = Library.Theme.TextDark,
                        BackgroundTransparency = 1
                    }):Play()
                end
            end
            
            TweenService:Create(TabButton, TweenInfo.new(0.2), {
                TextColor3 = Library.Theme.Accent,
                BackgroundTransparency = 0.9
            }):Play()
        end)
        
        -- Button creation function
        function tab:CreateButton(text, callback)
            callback = callback or function() end
            
            local Button = Create "TextButton" {
                Name = text,
                Size = UDim2.new(1, 0, 0, 32),
                BackgroundColor3 = Library.Theme.InputBackground,
                BorderSizePixel = 0,
                Text = text,
                TextColor3 = Library.Theme.TextColor,
                TextSize = 13,
                Font = Enum.Font.SFProDisplay,
                Parent = TabContainer
            }
            
            Create "UICorner" {
                CornerRadius = UDim.new(0, 6),
                Parent = Button
            }
            
            Button.MouseEnter:Connect(function()
                TweenService:Create(Button, TweenInfo.new(0.2), {
                    BackgroundColor3 = Library.Theme.Accent
                }):Play()
            end)
            
            Button.MouseLeave:Connect(function()
                TweenService:Create(Button, TweenInfo.new(0.2), {
                    BackgroundColor3 = Library.Theme.InputBackground
                }):Play()
            end)
            
            Button.MouseButton1Click:Connect(function()
                callback()
                
                TweenService:Create(Button, TweenInfo.new(0.1), {
                    Size = UDim2.new(1, 0, 0, 30)
                }):Play()
                wait(0.1)
                TweenService:Create(Button, TweenInfo.new(0.1), {
                    Size = UDim2.new(1, 0, 0, 32)
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
