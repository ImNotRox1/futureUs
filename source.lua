local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Library = {
    Theme = {
        Primary = Color3.fromRGB(20, 20, 30),
        Secondary = Color3.fromRGB(30, 30, 45),
        Accent = Color3.fromRGB(100, 190, 255),
        AccentDark = Color3.fromRGB(70, 130, 180),
        Text = Color3.fromRGB(240, 240, 240),
        TextDark = Color3.fromRGB(160, 160, 160),
        Background = Color3.fromRGB(15, 15, 20),
        DarkContrast = Color3.fromRGB(12, 12, 18),
        Glow = Color3.fromRGB(100, 190, 255)
    },
    Flags = {},
    ToggleKey = Enum.KeyCode.RightShift,
    Windows = {} -- Add this to track all windows
}

-- Utility Functions
local function Create(instanceType)
    return function(properties)
        local instance = Instance.new(instanceType)
        for property, value in pairs(properties) do
            instance[property] = value
        end
        return instance
    end
end

local function AddRippleEffect(button)
    local ripple = Create "Frame" {
        Name = "Ripple",
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
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

local function AddGlow(button)
    local glow = Create "ImageLabel" {
        Name = "Glow",
        BackgroundTransparency = 1,
        Image = "rbxassetid://7603818383",
        ImageColor3 = Library.Theme.Glow,
        ImageTransparency = 0.8,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = UDim2.new(1, 25, 1, 25),
        Parent = button
    }
    return glow
end

function Library:CreateWindow(title)
    local window = {}
    
    -- Main GUI
    local ScreenGui = Create "ScreenGui" {
        Name = "ModernUI",
        ResetOnSpawn = false
    }
    
    -- Handle different environments
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
        Size = UDim2.new(0, 600, 0, 400),
        Position = UDim2.new(0.5, -300, 0.5, -200),
        BackgroundColor3 = Library.Theme.Background,
        BorderSizePixel = 0,
        Parent = ScreenGui,
        Visible = true
    }
    
    -- Add shadow
    local Shadow = Create "ImageLabel" {
        Name = "Shadow",
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(1, 47, 1, 47),
        ZIndex = 0,
        Image = "rbxassetid://6015897843",
        ImageColor3 = Color3.new(0, 0, 0),
        ImageTransparency = 0.5,
        Parent = MainFrame
    }
    
    Create "UICorner" {
        CornerRadius = UDim.new(0, 8),
        Parent = MainFrame
    }
    
    -- Top bar with new modern design
    local TopBar = Create "Frame" {
        Name = "TopBar",
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = Library.Theme.DarkContrast,
        BorderSizePixel = 0,
        Parent = MainFrame
    }
    
    Create "UICorner" {
        CornerRadius = UDim.new(0, 8),
        Parent = TopBar
    }
    
    -- Title with icon
    local TitleContainer = Create "Frame" {
        Name = "TitleContainer",
        Size = UDim2.new(1, -20, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Parent = TopBar
    }
    
    local TitleIcon = Create "ImageLabel" {
        Name = "Icon",
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(0, 0, 0.5, -10),
        BackgroundTransparency = 1,
        Image = "rbxassetid://8997386536",
        ImageColor3 = Library.Theme.Accent,
        Parent = TitleContainer
    }
    
    local TitleText = Create "TextLabel" {
        Name = "Title",
        Text = title,
        Size = UDim2.new(1, -30, 1, 0),
        Position = UDim2.new(0, 30, 0, 0),
        BackgroundTransparency = 1,
        TextColor3 = Library.Theme.Text,
        TextSize = 16,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = TitleContainer
    }
    
    -- Close button
    local CloseButton = Create "ImageButton" {
        Name = "CloseButton",
        Size = UDim2.new(0, 24, 0, 24),
        Position = UDim2.new(1, -32, 0, 8),
        BackgroundTransparency = 1,
        Image = "rbxassetid://8997387827",
        ImageColor3 = Library.Theme.TextDark,
        Parent = TopBar
    }
    
    CloseButton.MouseEnter:Connect(function()
        TweenService:Create(CloseButton, TweenInfo.new(0.2), {
            ImageColor3 = Library.Theme.Accent
        }):Play()
    end)
    
    CloseButton.MouseLeave:Connect(function()
        TweenService:Create(CloseButton, TweenInfo.new(0.2), {
            ImageColor3 = Library.Theme.TextDark
        }):Play()
    end)
    
    CloseButton.MouseButton1Click:Connect(function()
        window:Destroy()
    end)
    
    -- Container for tabs
    local TabContainer = Create "Frame" {
        Name = "TabContainer",
        Size = UDim2.new(0, 150, 1, -50),
        Position = UDim2.new(0, 10, 0, 45),
        BackgroundColor3 = Library.Theme.Primary,
        BorderSizePixel = 0,
        Parent = MainFrame
    }
    
    Create "UICorner" {
        CornerRadius = UDim.new(0, 8),
        Parent = TabContainer
    }
    
    local TabList = Create "ScrollingFrame" {
        Name = "TabList",
        Size = UDim2.new(1, -10, 1, -10),
        Position = UDim2.new(0, 5, 0, 5),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = Library.Theme.Accent,
        Parent = TabContainer
    }
    
    local TabListLayout = Create "UIListLayout" {
        Padding = UDim.new(0, 5),
        Parent = TabList
    }
    
    -- Content container
    local ContentContainer = Create "Frame" {
        Name = "ContentContainer",
        Size = UDim2.new(1, -180, 1, -50),
        Position = UDim2.new(0, 170, 0, 45),
        BackgroundTransparency = 1,
        Parent = MainFrame
    }
    
    -- Toggle UI with key
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == Library.ToggleKey then
            MainFrame.Visible = not MainFrame.Visible
        end
    end)
    
    -- Make window draggable with smooth dragging
    local dragging, dragInput, dragStart, startPos
    
    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            
            local inputChanged = input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
            table.insert(window.Connections, inputChanged)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input == dragInput then
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
    
    function window:CreateTab(name)
        local tab = {}
        
        -- Tab button
        local TabButton = Create "TextButton" {
            Name = name,
            Size = UDim2.new(1, 0, 0, 35),
            BackgroundColor3 = Library.Theme.Secondary,
            BorderSizePixel = 0,
            Text = name,
            TextColor3 = Library.Theme.TextDark,
            TextSize = 14,
            Font = Enum.Font.GothamMedium,
            Parent = TabList
        }
        
        Create "UICorner" {
            CornerRadius = UDim.new(0, 6),
            Parent = TabButton
        }
        
        -- Tab content
        local TabContent = Create "ScrollingFrame" {
            Name = name.."Content",
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ScrollBarThickness = 2,
            ScrollBarImageColor3 = Library.Theme.Accent,
            Visible = false,
            Parent = ContentContainer
        }
        
        local ContentLayout = Create "UIListLayout" {
            Padding = UDim.new(0, 10),
            Parent = TabContent
        }
        
        -- Tab button effects
        TabButton.MouseEnter:Connect(function()
            TweenService:Create(TabButton, TweenInfo.new(0.2), {
                BackgroundColor3 = Library.Theme.Accent,
                TextColor3 = Library.Theme.Text
            }):Play()
        end)
        
        TabButton.MouseLeave:Connect(function()
            if TabContent.Visible == false then
                TweenService:Create(TabButton, TweenInfo.new(0.2), {
                    BackgroundColor3 = Library.Theme.Secondary,
                    TextColor3 = Library.Theme.TextDark
                }):Play()
            end
        end)
        
        TabButton.MouseButton1Click:Connect(function()
            for _, v in pairs(ContentContainer:GetChildren()) do
                if v:IsA("ScrollingFrame") then
                    v.Visible = false
                end
            end
            TabContent.Visible = true
            
            for _, v in pairs(TabList:GetChildren()) do
                if v:IsA("TextButton") then
                    TweenService:Create(v, TweenInfo.new(0.2), {
                        BackgroundColor3 = Library.Theme.Secondary,
                        TextColor3 = Library.Theme.TextDark
                    }):Play()
                end
            end
            
            TweenService:Create(TabButton, TweenInfo.new(0.2), {
                BackgroundColor3 = Library.Theme.Accent,
                TextColor3 = Library.Theme.Text
            }):Play()
        end)
        
        -- Create elements in tab
        function tab:CreateButton(text, callback)
            callback = callback or function() end
            
            local Button = Create "TextButton" {
                Name = text,
                Size = UDim2.new(1, 0, 0, 35),
                BackgroundColor3 = Library.Theme.Secondary,
                BorderSizePixel = 0,
                Text = text,
                TextColor3 = Library.Theme.Text,
                TextSize = 14,
                Font = Enum.Font.GothamMedium,
                Parent = TabContent
            }
            
            Create "UICorner" {
                CornerRadius = UDim.new(0, 6),
                Parent = Button
            }
            
            -- Button effects
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
            
            Button.MouseButton1Click:Connect(function()
                callback()
                
                -- Click effect
                TweenService:Create(Button, TweenInfo.new(0.1), {
                    Size = UDim2.new(1, 0, 0, 32)
                }):Play()
                
                wait(0.1)
                
                TweenService:Create(Button, TweenInfo.new(0.1), {
                    Size = UDim2.new(1, 0, 0, 35)
                }):Play()
            end)
        end
        
        return tab
    end
    
    -- Add destroy function
    function window:Destroy()
        -- Remove all connections
        for _, connection in pairs(window.Connections or {}) do
            connection:Disconnect()
        end
        
        -- Destroy the ScreenGui with a fade out animation
        TweenService:Create(MainFrame, TweenInfo.new(0.2), {
            BackgroundTransparency = 1
        }):Play()
        
        -- Remove from Library.Windows
        for i, w in pairs(Library.Windows) do
            if w == window then
                table.remove(Library.Windows, i)
                break
            end
        end
        
        task.wait(0.2)
        ScreenGui:Destroy()
    end
    
    -- Store connections for cleanup
    window.Connections = {}
    
    -- Add window to Library.Windows
    table.insert(Library.Windows, window)
    
    return window
end

-- Add global destroy function
function Library:DestroyAll()
    for _, window in pairs(self.Windows) do
        window:Destroy()
    end
    self.Windows = {}
end

return Library
