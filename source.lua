local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Library = {
    Theme = {
        Background = Color3.fromRGB(17, 17, 17),
        Accent = Color3.fromRGB(65, 65, 65),
        Secondary = Color3.fromRGB(25, 25, 25),
        Text = Color3.fromRGB(240, 240, 240),
        TextDark = Color3.fromRGB(150, 150, 150),
        Glow = Color3.fromRGB(65, 65, 65)
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
    
    local MainFrame = Create "Frame" {
        Name = "MainFrame",
        Size = UDim2.new(0, 300, 0, 350),
        Position = UDim2.new(0.5, -150, 0.5, -175),
        BackgroundColor3 = Library.Theme.Background,
        BorderSizePixel = 0,
        Parent = ScreenGui
    }
    
    Create "UICorner" {
        CornerRadius = UDim.new(0, 6),
        Parent = MainFrame
    }
    
    -- Search bar at top
    local SearchBar = Create "Frame" {
        Name = "SearchBar",
        Size = UDim2.new(1, -20, 0, 35),
        Position = UDim2.new(0, 10, 0, 10),
        BackgroundColor3 = Library.Theme.Secondary,
        BorderSizePixel = 0,
        Parent = MainFrame
    }
    
    Create "UICorner" {
        CornerRadius = UDim.new(0, 6),
        Parent = SearchBar
    }
    
    local SearchIcon = Create "ImageLabel" {
        Name = "SearchIcon",
        Size = UDim2.new(0, 16, 0, 16),
        Position = UDim2.new(0, 10, 0.5, -8),
        BackgroundTransparency = 1,
        Image = "rbxassetid://8150715986",
        ImageColor3 = Library.Theme.TextDark,
        Parent = SearchBar
    }
    
    local SearchBox = Create "TextBox" {
        Name = "SearchBox",
        Size = UDim2.new(1, -40, 1, 0),
        Position = UDim2.new(0, 35, 0, 0),
        BackgroundTransparency = 1,
        Text = "",
        PlaceholderText = "Search...",
        TextColor3 = Library.Theme.Text,
        PlaceholderColor3 = Library.Theme.TextDark,
        TextSize = 14,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = SearchBar
    }
    
    -- Tab Container
    local TabContainer = Create "Frame" {
        Name = "TabContainer",
        Size = UDim2.new(1, -20, 1, -60),
        Position = UDim2.new(0, 10, 0, 55),
        BackgroundColor3 = Library.Theme.Secondary,
        BorderSizePixel = 0,
        Parent = MainFrame
    }
    
    Create "UICorner" {
        CornerRadius = UDim.new(0, 6),
        Parent = TabContainer
    }
    
    local TabList = Create "ScrollingFrame" {
        Name = "TabList",
        Size = UDim2.new(1, -10, 1, -10),
        Position = UDim2.new(0, 5, 0, 5),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 0,
        Parent = TabContainer
    }
    
    local TabListLayout = Create "UIListLayout" {
        Padding = UDim.new(0, 5),
        Parent = TabList
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
    
    function window:CreateTab(name)
        local tab = {}
        
        local TabButton = Create "TextButton" {
            Name = name,
            Size = UDim2.new(1, 0, 0, 35),
            BackgroundColor3 = Library.Theme.Background,
            BorderSizePixel = 0,
            Text = name,
            TextColor3 = Library.Theme.TextDark,
            TextSize = 14,
            Font = Enum.Font.Gotham,
            Parent = TabList
        }
        
        Create "UICorner" {
            CornerRadius = UDim.new(0, 4),
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
            
            for _, v in pairs(TabList:GetChildren()) do
                if v:IsA("TextButton") then
                    TweenService:Create(v, TweenInfo.new(0.2), {
                        BackgroundColor3 = Library.Theme.Background,
                        TextColor3 = Library.Theme.TextDark
                    }):Play()
                end
            end
            
            TweenService:Create(TabButton, TweenInfo.new(0.2), {
                BackgroundColor3 = Library.Theme.Accent,
                TextColor3 = Library.Theme.Text
            }):Play()
        end)
        
        function tab:CreateButton(text, callback)
            callback = callback or function() end
            
            local Button = Create "TextButton" {
                Name = text,
                Size = UDim2.new(1, -10, 0, 32),
                Position = UDim2.new(0, 5, 0, 0),
                BackgroundColor3 = Library.Theme.Background,
                BorderSizePixel = 0,
                Text = text,
                TextColor3 = Library.Theme.Text,
                TextSize = 14,
                Font = Enum.Font.Gotham,
                Parent = TabContent
            }
            
            Create "UICorner" {
                CornerRadius = UDim.new(0, 4),
                Parent = Button
            }
            
            Button.MouseEnter:Connect(function()
                TweenService:Create(Button, TweenInfo.new(0.2), {
                    BackgroundColor3 = Library.Theme.Accent
                }):Play()
            end)
            
            Button.MouseLeave:Connect(function()
                TweenService:Create(Button, TweenInfo.new(0.2), {
                    BackgroundColor3 = Library.Theme.Background
                }):Play()
            end)
            
            Button.MouseButton1Click:Connect(function()
                callback()
                TweenService:Create(Button, TweenInfo.new(0.1), {
                    Size = UDim2.new(1, -10, 0, 30)
                }):Play()
                wait(0.1)
                TweenService:Create(Button, TweenInfo.new(0.1), {
                    Size = UDim2.new(1, -10, 0, 32)
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
