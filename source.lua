local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Library = {
    Theme = {
        Primary = Color3.fromRGB(24, 24, 36),
        Secondary = Color3.fromRGB(32, 32, 48),
        Accent = Color3.fromRGB(96, 76, 215),
        Text = Color3.fromRGB(255, 255, 255),
        TextDark = Color3.fromRGB(175, 175, 175),
        Background = Color3.fromRGB(18, 18, 28)
    }
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

function Library:CreateWindow(title)
    local window = {}
    
    -- Main GUI
    local ScreenGui = Create "ScreenGui" {
        Name = "ModernUI",
        ResetOnSpawn = false
    }
    
    -- Handle different environments (executor vs Roblox Studio)
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
        Size = UDim2.new(0, 650, 0, 450),
        Position = UDim2.new(0.5, -325, 0.5, -225),
        BackgroundColor3 = Library.Theme.Background,
        BorderSizePixel = 0,
        Parent = ScreenGui
    }
    
    -- Main corner radius
    Create "UICorner" {
        CornerRadius = UDim.new(0, 10),
        Parent = MainFrame
    }
    
    -- Add gradient
    local Gradient = Create "UIGradient" {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(230, 230, 230))
        }),
        Rotation = 45,
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.95),
            NumberSequenceKeypoint.new(1, 0.97)
        }),
        Parent = MainFrame
    }
    
    -- Top bar
    local TopBar = Create "Frame" {
        Name = "TopBar",
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = Library.Theme.Primary,
        BorderSizePixel = 0,
        Parent = MainFrame
    }
    
    Create "UICorner" {
        CornerRadius = UDim.new(0, 10),
        Parent = TopBar
    }
    
    -- Title
    local TitleLabel = Create "TextLabel" {
        Name = "Title",
        Text = title,
        Size = UDim2.new(1, -20, 1, 0),
        Position = UDim2.new(0, 20, 0, 0),
        BackgroundTransparency = 1,
        TextColor3 = Library.Theme.Text,
        TextSize = 18,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = TopBar
    }
    
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
    
    -- Make window draggable
    local dragging, dragInput, dragStart, startPos
    
    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    MainFrame:GetPropertyChangedSignal("Position"):Connect(function()
        if dragging then
            local delta = dragInput.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
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
    
    return window
end

return Library
