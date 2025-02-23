local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

local Library = {
    Theme = {
        Background = Color3.fromRGB(18, 18, 23),
        Accent = Color3.fromRGB(72, 95, 255),
        AccentDark = Color3.fromRGB(52, 75, 235),
        Secondary = Color3.fromRGB(22, 22, 28),
        Divider = Color3.fromRGB(25, 25, 32),
        Text = Color3.fromRGB(240, 240, 240),
        TextDark = Color3.fromRGB(180, 180, 190),
        InputBackground = Color3.fromRGB(28, 28, 36),
        Hover = Color3.fromRGB(32, 32, 40),
        Stroke = Color3.fromRGB(45, 45, 55)
    },
    Flags = {},
    ToggleKey = Enum.KeyCode.RightShift,
    Windows = {},
    Opened = true
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

local function CreateGlow(parent)
    local glow = Create "ImageLabel" {
        Name = "Glow",
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(1, 25, 1, 25),
        ZIndex = 0,
        Image = "rbxassetid://7603818383",
        ImageColor3 = Library.Theme.Accent,
        ImageTransparency = 0.8,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Parent = parent
    }
    return glow
end

local function CreateStroke(parent, transparency)
    return Create "UIStroke" {
        Color = Library.Theme.Stroke,
        Transparency = transparency or 0.5,
        Thickness = 1,
        Parent = parent
    }
end

local function CreateShadow(parent)
    local shadow = Create "ImageLabel" {
        Name = "Shadow",
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(1, 47, 1, 47),
        ZIndex = 0,
        Image = "rbxassetid://6015897843",
        ImageColor3 = Color3.new(0, 0, 0),
        ImageTransparency = 0.5,
        Parent = parent
    }
    return shadow
end

function Library:CreateWindow(title)
    -- Cleanup previous instances
    local previousGui = game:GetService("CoreGui"):FindFirstChild("VisionLibrary")
    if previousGui then
        previousGui:Destroy()
    end
    
    local window = {}
    
    -- Main GUI
    local ScreenGui = Create "ScreenGui" {
        Name = "VisionLibrary",
        ResetOnSpawn = false
    }
    
    -- Try different methods to parent the GUI
    pcall(function()
        if syn then
            syn.protect_gui(ScreenGui)
            ScreenGui.Parent = game:GetService("CoreGui")
        elseif gethui then
            ScreenGui.Parent = gethui()
        else
            ScreenGui.Parent = game:GetService("CoreGui")
        end
    end)
    
    -- Main container
    local MainFrame = Create "Frame" {
        Name = "MainFrame",
        Size = UDim2.new(0, 500, 0, 350),
        Position = UDim2.new(0.5, -250, 0.5, -175),
        BackgroundColor3 = Library.Theme.Background,
        BorderSizePixel = 0,
        Parent = ScreenGui
    }
    
    Create "UICorner" {
        CornerRadius = UDim.new(0, 6),
        Parent = MainFrame
    }
    
    -- Top bar
    local TopBar = Create "Frame" {
        Name = "TopBar",
        Size = UDim2.new(1, 0, 0, 35),
        BackgroundColor3 = Library.Theme.Secondary,
        BorderSizePixel = 0,
        Parent = MainFrame
    }
    
    Create "UICorner" {
        CornerRadius = UDim.new(0, 6),
        Parent = TopBar
    }
    
    -- Title
    local TitleText = Create "TextLabel" {
        Name = "Title",
        Size = UDim2.new(1, -20, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = Library.Theme.Text,
        TextSize = 14,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = TopBar
    }
    
    -- Tab system
    local TabButtons = Create "Frame" {
        Name = "TabButtons",
        Size = UDim2.new(0, 130, 1, -45),
        Position = UDim2.new(0, 10, 0, 40),
        BackgroundColor3 = Library.Theme.Secondary,
        BorderSizePixel = 0,
        Parent = MainFrame
    }
    
    Create "UICorner" {
        CornerRadius = UDim.new(0, 6),
        Parent = TabButtons
    }
    
    local TabContainer = Create "Frame" {
        Name = "TabContainer",
        Size = UDim2.new(1, -160, 1, -45),
        Position = UDim2.new(0, 150, 0, 40),
        BackgroundColor3 = Library.Theme.Secondary,
        BorderSizePixel = 0,
        Parent = MainFrame
    }
    
    Create "UICorner" {
        CornerRadius = UDim.new(0, 6),
        Parent = TabContainer
    }
    
    function window:CreateTab(name)
        local tab = {}
        
        local TabButton = Create "TextButton" {
            Name = name,
            Size = UDim2.new(1, -20, 0, 30),
            Position = UDim2.new(0, 10, 0, #TabButtons:GetChildren() * 35),
            BackgroundColor3 = Library.Theme.InputBackground,
            BorderSizePixel = 0,
            Text = name,
            TextColor3 = Library.Theme.Text,
            TextSize = 14,
            Font = Enum.Font.Gotham,
            Parent = TabButtons
        }
        
        Create "UICorner" {
            CornerRadius = UDim.new(0, 4),
            Parent = TabButton
        }
        
        local TabPage = Create "Frame" {
            Name = name.."Page",
            Size = UDim2.new(1, -20, 1, -20),
            Position = UDim2.new(0, 10, 0, 10),
            BackgroundTransparency = 1,
            Visible = false,
            Parent = TabContainer
        }
        
        function tab:CreateButton(text, callback)
            callback = callback or function() end
            
            local Button = Create "TextButton" {
                Name = text,
                Size = UDim2.new(1, 0, 0, 30),
                Position = UDim2.new(0, 0, 0, #TabPage:GetChildren() * 35),
                BackgroundColor3 = Library.Theme.InputBackground,
                BorderSizePixel = 0,
                Text = text,
                TextColor3 = Library.Theme.Text,
                TextSize = 14,
                Font = Enum.Font.Gotham,
                Parent = TabPage
            }
            
            Create "UICorner" {
                CornerRadius = UDim.new(0, 4),
                Parent = Button
            }
            
            Button.MouseButton1Click:Connect(callback)
        end
        
        TabButton.MouseButton1Click:Connect(function()
            for _, v in pairs(TabContainer:GetChildren()) do
                v.Visible = false
            end
            TabPage.Visible = true
        end)
        
        -- Show first tab by default
        if #TabButtons:GetChildren() == 1 then
            TabPage.Visible = true
        end
        
        return tab
    end
    
    -- Make window draggable
    local dragging = false
    local dragStart, startPos
    
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
    
    return window
end

return Library
