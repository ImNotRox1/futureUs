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
    for _, gui in pairs(CoreGui:GetChildren()) do
        if gui.Name == "VisionLibrary" then
            gui:Destroy()
        end
    end
    
    local window = {
        Tabs = {},
        Minimized = false
    }
    
    -- Main GUI
    local ScreenGui = Create "ScreenGui" {
        Name = "VisionLibrary",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    }
    
    -- Handle different environments
    if syn then
        syn.protect_gui(ScreenGui)
        ScreenGui.Parent = CoreGui
    elseif gethui then
        ScreenGui.Parent = gethui()
    else
        ScreenGui.Parent = CoreGui
    end

    -- Would you like me to continue with:
    -- 1. Main container and design
    -- 2. Tab system
    -- 3. UI elements (buttons, toggles, etc.)
    -- 4. Additional features

    return window
end

return Library
