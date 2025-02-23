local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local Library = {
    Theme = {
        Primary = Color3.fromRGB(24, 24, 32),
        Secondary = Color3.fromRGB(28, 28, 36),
        Accent = Color3.fromRGB(90, 105, 255),
        Hover = Color3.fromRGB(32, 32, 40),
        Text = Color3.fromRGB(240, 240, 240),
        TextDark = Color3.fromRGB(160, 160, 160),
        InputBackground = Color3.fromRGB(36, 36, 44),
        Stroke = Color3.fromRGB(45, 45, 55),
        Object = Color3.fromRGB(32, 32, 40)
    },
    Flags = {},
    ToggleKey = Enum.KeyCode.RightShift,
    Windows = {}
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

local function CreateStroke(parent)
    return Create "UIStroke" {
        Color = Library.Theme.Stroke,
        Thickness = 1.5,
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
        if gui.Name == "ModernUI" then
            gui:Destroy()
        end
    end
    
    local window = {}
    
    -- Main GUI
    local ScreenGui = Create "ScreenGui" {
        Name = "ModernUI",
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
    
    -- Main container
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
    
    CreateStroke(MainFrame)
    CreateShadow(MainFrame)
    
    -- Top bar
    local TopBar = Create "Frame" {
        Name = "TopBar",
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = Library.Theme.Secondary,
        BorderSizePixel = 0,
        Parent = MainFrame
    }
    
    Create "UICorner" {
        CornerRadius = UDim.new(0, 8),
        Parent = TopBar
    }
    
    -- Title
    local TitleContainer = Create "Frame" {
        Name = "TitleContainer",
        Size = UDim2.new(0, 200, 1, 0),
        BackgroundTransparency = 1,
        Parent = TopBar
    }
    
    local TitleText = Create "TextLabel" {
        Name = "Title",
        Size = UDim2.new(1, -20, 1, 0),
        Position = UDim2.new(0, 15, 0, 0),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = Library.Theme.Text,
        TextSize = 15,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = TitleContainer
    }
    
    -- Navigation
    local Navigation = Create "Frame" {
        Name = "Navigation",
        Size = UDim2.new(0, 150, 1, -50),
        Position = UDim2.new(0, 10, 0, 45),
        BackgroundColor3 = Library.Theme.Secondary,
        BorderSizePixel = 0,
        Parent = MainFrame
    }
    
    Create "UICorner" {
        CornerRadius = UDim.new(0, 6),
        Parent = Navigation
    }
    
    local TabContainer = Create "ScrollingFrame" {
        Name = "TabContainer",
        Size = UDim2.new(1, -10, 1, -10),
        Position = UDim2.new(0, 5, 0, 5),
        BackgroundTransparency = 1,
        ScrollBarThickness = 0,
        ScrollingEnabled = true,
        Parent = Navigation
    }
    
    local TabListLayout = Create "UIListLayout" {
        Padding = UDim.new(0, 5),
        Parent = TabContainer
    }
    
    -- Content area
    local ContentArea = Create "Frame" {
        Name = "ContentArea",
        Size = UDim2.new(1, -180, 1, -50),
        Position = UDim2.new(0, 170, 0, 45),
        BackgroundColor3 = Library.Theme.Secondary,
        BorderSizePixel = 0,
        Parent = MainFrame
    }
    
    Create "UICorner" {
        CornerRadius = UDim.new(0, 6),
        Parent = ContentArea
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
    
    -- Continue with tab system and elements...
    
    return window
end

function window:CreateTab(name)
    local tab = {}
    
    -- Create tab button
    local TabButton = Create "TextButton" {
        Name = name,
        Size = UDim2.new(1, -10, 0, 32),
        BackgroundColor3 = Library.Theme.Object,
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
    
    -- Create tab content
    local TabContent = Create "ScrollingFrame" {
        Name = name.."Content",
        Size = UDim2.new(1, -20, 1, -20),
        Position = UDim2.new(0, 10, 0, 10),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = Library.Theme.Accent,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Visible = false,
        Parent = ContentArea
    }
    
    local ContentLayout = Create "UIListLayout" {
        Padding = UDim.new(0, 6),
        Parent = TabContent
    }

    -- Make first tab visible by default
    if #TabContainer:GetChildren() == 1 then
        TabContent.Visible = true
        TabButton.BackgroundTransparency = 0
        TabButton.TextColor3 = Library.Theme.Text
    end
    
    TabButton.MouseButton1Click:Connect(function()
        -- Hide all other tabs
        for _, v in pairs(ContentArea:GetChildren()) do
            if v:IsA("ScrollingFrame") then
                v.Visible = false
            end
        end
        TabContent.Visible = true
        
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
    
    -- Button creator
    function tab:CreateButton(text, callback)
        callback = callback or function() end
        
        local Button = Create "TextButton" {
            Name = text,
            Size = UDim2.new(1, 0, 0, 32),
            BackgroundColor3 = Library.Theme.Object,
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
        
        Button.MouseEnter:Connect(function()
            TweenService:Create(Button, TweenInfo.new(0.2), {
                BackgroundColor3 = Library.Theme.Accent
            }):Play()
        end)
        
        Button.MouseLeave:Connect(function()
            TweenService:Create(Button, TweenInfo.new(0.2), {
                BackgroundColor3 = Library.Theme.Object
            }):Play()
        end)
        
        Button.MouseButton1Click:Connect(callback)
    end
    
    return tab
end

return Library
