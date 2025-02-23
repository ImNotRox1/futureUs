local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Library = {
    Theme = {
        Background = Color3.fromRGB(15, 15, 15),
        DarkContrast = Color3.fromRGB(10, 10, 10),
        TextColor = Color3.fromRGB(240, 240, 240),
        TextDark = Color3.fromRGB(150, 150, 150),
        Accent = Color3.fromRGB(252, 61, 61),
        InputBackground = Color3.fromRGB(25, 25, 25)
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
        Size = UDim2.new(0, 250, 0, 300),
        Position = UDim2.new(0.5, -125, 0.5, -150),
        BackgroundColor3 = Library.Theme.Background,
        BorderSizePixel = 0,
        Parent = ScreenGui
    }
    
    Create "UICorner" {
        CornerRadius = UDim.new(0, 4),
        Parent = MainFrame
    }
    
    -- Left sidebar
    local Sidebar = Create "Frame" {
        Name = "Sidebar",
        Size = UDim2.new(0, 40, 1, 0),
        BackgroundColor3 = Library.Theme.DarkContrast,
        BorderSizePixel = 0,
        Parent = MainFrame
    }
    
    Create "UICorner" {
        CornerRadius = UDim.new(0, 4),
        Parent = Sidebar
    }
    
    -- Content area
    local ContentArea = Create "Frame" {
        Name = "ContentArea",
        Size = UDim2.new(1, -45, 1, -10),
        Position = UDim2.new(0, 45, 0, 5),
        BackgroundTransparency = 1,
        Parent = MainFrame
    }
    
    -- Search bar
    local SearchBar = Create "Frame" {
        Name = "SearchBar",
        Size = UDim2.new(1, -10, 0, 30),
        Position = UDim2.new(0, 5, 0, 5),
        BackgroundColor3 = Library.Theme.InputBackground,
        BorderSizePixel = 0,
        Parent = ContentArea
    }
    
    Create "UICorner" {
        CornerRadius = UDim.new(0, 4),
        Parent = SearchBar
    }
    
    local SearchBox = Create "TextBox" {
        Name = "SearchBox",
        Size = UDim2.new(1, -16, 1, -8),
        Position = UDim2.new(0, 8, 0, 4),
        BackgroundTransparency = 1,
        Text = "",
        PlaceholderText = "Search...",
        TextColor3 = Library.Theme.TextColor,
        PlaceholderColor3 = Library.Theme.TextDark,
        TextSize = 12,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = SearchBar
    }
    
    -- Tab container
    local TabContainer = Create "ScrollingFrame" {
        Name = "TabContainer",
        Size = UDim2.new(1, -10, 1, -45),
        Position = UDim2.new(0, 5, 0, 40),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 0,
        ScrollingEnabled = true,
        Parent = ContentArea
    }
    
    local TabListLayout = Create "UIListLayout" {
        Padding = UDim.new(0, 5),
        Parent = TabContainer
    }
    
    -- Make window draggable
    local dragging, dragInput, dragStart, startPos
    
    MainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(
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
    
    function window:CreateTab(name)
        local tab = {}
        
        local TabButton = Create "TextButton" {
            Name = name,
            Size = UDim2.new(1, 0, 0, 30),
            BackgroundColor3 = Library.Theme.InputBackground,
            BorderSizePixel = 0,
            Text = "",
            Parent = TabContainer
        }
        
        Create "UICorner" {
            CornerRadius = UDim.new(0, 4),
            Parent = TabButton
        }
        
        local TabLabel = Create "TextLabel" {
            Name = "Label",
            Size = UDim2.new(1, -8, 1, 0),
            Position = UDim2.new(0, 8, 0, 0),
            BackgroundTransparency = 1,
            Text = name,
            TextColor3 = Library.Theme.TextDark,
            TextSize = 12,
            Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = TabButton
        }
        
        local TabContent = Create "Frame" {
            Name = name.."Content",
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Visible = false,
            Parent = TabContainer
        }
        
        local ContentList = Create "UIListLayout" {
            Padding = UDim.new(0, 5),
            Parent = TabContent
        }
        
        TabButton.MouseButton1Click:Connect(function()
            for _, v in pairs(TabContainer:GetChildren()) do
                if v:IsA("Frame") and v.Name:find("Content") then
                    v.Visible = false
                end
            end
            TabContent.Visible = true
            
            for _, v in pairs(TabContainer:GetChildren()) do
                if v:IsA("TextButton") then
                    TweenService:Create(v.Label, TweenInfo.new(0.2), {
                        TextColor3 = Library.Theme.TextDark
                    }):Play()
                end
            end
            
            TweenService:Create(TabLabel, TweenInfo.new(0.2), {
                TextColor3 = Library.Theme.TextColor
            }):Play()
        end)
        
        function tab:CreateButton(text, callback)
            callback = callback or function() end
            
            local Button = Create "TextButton" {
                Name = text,
                Size = UDim2.new(1, 0, 0, 30),
                BackgroundColor3 = Library.Theme.InputBackground,
                BorderSizePixel = 0,
                Text = "",
                Parent = TabContent
            }
            
            Create "UICorner" {
                CornerRadius = UDim.new(0, 4),
                Parent = Button
            }
            
            local ButtonLabel = Create "TextLabel" {
                Name = "Label",
                Size = UDim2.new(1, -8, 1, 0),
                Position = UDim2.new(0, 8, 0, 0),
                BackgroundTransparency = 1,
                Text = text,
                TextColor3 = Library.Theme.TextColor,
                TextSize = 12,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left,
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
                    Size = UDim2.new(1, 0, 0, 28)
                }):Play()
                wait(0.1)
                TweenService:Create(Button, TweenInfo.new(0.1), {
                    Size = UDim2.new(1, 0, 0, 30)
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
