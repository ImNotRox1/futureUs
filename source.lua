local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local Library = {
    Theme = {
        Primary = Color3.fromRGB(18, 18, 24),       -- Main background
        Secondary = Color3.fromRGB(22, 22, 30),     -- Lighter background
        Accent = Color3.fromRGB(85, 100, 240),      -- Accent color
        Hover = Color3.fromRGB(32, 32, 40),         -- Hover effect
        Text = Color3.fromRGB(240, 240, 240),       -- Primary text
        TextDark = Color3.fromRGB(160, 160, 160),   -- Secondary text
        Border = Color3.fromRGB(30, 30, 38)         -- Border color
    }
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
    -- Cleanup previous UI
    for _, gui in pairs(CoreGui:GetChildren()) do
        if gui.Name == "VisionLibrary" then
            gui:Destroy()
        end
    end
    
    local window = {
        Tabs = {},
        CurrentTab = nil,
        Toggled = true
    }
    
    -- Create main GUI
    local ScreenGui = Create "ScreenGui" {
        Name = "VisionLibrary",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    }
    
    -- Handle different executors
    pcall(function()
        if syn then
            syn.protect_gui(ScreenGui)
            ScreenGui.Parent = CoreGui
        elseif gethui then
            ScreenGui.Parent = gethui()
        else
            ScreenGui.Parent = CoreGui
        end
    end)
    
    -- Main container
    local Main = Create "Frame" {
        Name = "Main",
        Size = UDim2.new(0, 500, 0, 350),
        Position = UDim2.new(0.5, -250, 0.5, -175),
        BackgroundColor3 = Library.Theme.Primary,
        BorderSizePixel = 0,
        Parent = ScreenGui
    }
    
    Create "UICorner" {
        CornerRadius = UDim.new(0, 8),
        Parent = Main
    }
    
    -- Top bar
    local TopBar = Create "Frame" {
        Name = "TopBar",
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = Library.Theme.Secondary,
        BorderSizePixel = 0,
        Parent = Main
    }
    
    Create "UICorner" {
        CornerRadius = UDim.new(0, 8),
        Parent = TopBar
    }
    
    -- Title
    local Title = Create "TextLabel" {
        Name = "Title",
        Size = UDim2.new(1, -20, 1, 0),
        Position = UDim2.new(0, 15, 0, 0),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = Library.Theme.Text,
        TextSize = 15,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = TopBar
    }
    
    -- Navigation
    local Navigation = Create "Frame" {
        Name = "Navigation",
        Size = UDim2.new(0, 150, 1, -50),
        Position = UDim2.new(0, 10, 0, 45),
        BackgroundColor3 = Library.Theme.Secondary,
        BorderSizePixel = 0,
        Parent = Main
    }
    
    Create "UICorner" {
        CornerRadius = UDim.new(0, 6),
        Parent = Navigation
    }
    
    local TabList = Create "ScrollingFrame" {
        Name = "TabList",
        Size = UDim2.new(1, -10, 1, -10),
        Position = UDim2.new(0, 5, 0, 5),
        BackgroundTransparency = 1,
        ScrollBarThickness = 0,
        ScrollingEnabled = true,
        Parent = Navigation
    }
    
    local TabListLayout = Create "UIListLayout" {
        Padding = UDim.new(0, 5),
        Parent = TabList
    }
    
    -- Content area
    local Content = Create "Frame" {
        Name = "Content",
        Size = UDim2.new(1, -170, 1, -50),
        Position = UDim2.new(0, 165, 0, 45),
        BackgroundColor3 = Library.Theme.Secondary,
        BorderSizePixel = 0,
        Parent = Main
    }
    
    Create "UICorner" {
        CornerRadius = UDim.new(0, 6),
        Parent = Content
    }
    
    -- Create tab function
    function window:CreateTab(name)
        local tab = {}
        
        local TabButton = Create "TextButton" {
            Name = name,
            Size = UDim2.new(1, -10, 0, 32),
            BackgroundColor3 = Library.Theme.Primary,
            BackgroundTransparency = 0.9,
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
        
        local TabContent = Create "ScrollingFrame" {
            Name = name.."Content",
            Size = UDim2.new(1, -20, 1, -20),
            Position = UDim2.new(0, 10, 0, 10),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ScrollBarThickness = 2,
            ScrollBarImageColor3 = Library.Theme.Accent,
            Visible = false,
            Parent = Content
        }
        
        local ContentList = Create "UIListLayout" {
            Padding = UDim.new(0, 6),
            Parent = TabContent
        }
        
        -- Show first tab by default
        if #window.Tabs == 0 then
            TabContent.Visible = true
            TabButton.BackgroundTransparency = 0
            TabButton.TextColor3 = Library.Theme.Text
        end
        
        -- Tab button handler
        TabButton.MouseButton1Click:Connect(function()
            for _, v in pairs(window.Tabs) do
                v.Content.Visible = false
                v.Button.BackgroundTransparency = 0.9
                v.Button.TextColor3 = Library.Theme.TextDark
            end
            TabContent.Visible = true
            TabButton.BackgroundTransparency = 0
            TabButton.TextColor3 = Library.Theme.Text
        end)
        
        -- Button creator
        function tab:CreateButton(text, callback)
            callback = callback or function() end
            
            local Button = Create "TextButton" {
                Name = text,
                Size = UDim2.new(1, 0, 0, 32),
                BackgroundColor3 = Library.Theme.Primary,
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
                    BackgroundColor3 = Library.Theme.Hover
                }):Play()
            end)
            
            Button.MouseLeave:Connect(function()
                TweenService:Create(Button, TweenInfo.new(0.2), {
                    BackgroundColor3 = Library.Theme.Primary
                }):Play()
            end)
            
            Button.MouseButton1Click:Connect(callback)
        end
        
        -- Store tab data
        tab.Button = TabButton
        tab.Content = TabContent
        table.insert(window.Tabs, tab)
        
        return tab
    end
    
    -- Make window draggable
    local dragging = false
    local dragStart, startPos
    
    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = Main.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            Main.Position = UDim2.new(
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
