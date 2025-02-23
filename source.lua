local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- Colors (macOS style)
local COLORS = {
    Background = Color3.fromRGB(32, 32, 32),
    Secondary = Color3.fromRGB(40, 40, 40),
    TopBar = Color3.fromRGB(50, 50, 50),
    Accent = Color3.fromRGB(0, 122, 255),
    Red = Color3.fromRGB(255, 69, 58),
    Yellow = Color3.fromRGB(255, 214, 10),
    Green = Color3.fromRGB(48, 209, 88),
    Text = Color3.fromRGB(255, 255, 255),
    TextDark = Color3.fromRGB(180, 180, 180),
    ButtonHover = Color3.fromRGB(60, 60, 60)
}

-- Cleanup previous UI
for _, gui in pairs(CoreGui:GetChildren()) do
    if gui.Name == "MacUI" then
        gui:Destroy()
    end
end

-- Create the UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MacUI"
ScreenGui.ResetOnSpawn = false

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

-- Main Window
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 500, 0, 350)
Main.Position = UDim2.new(0.5, -250, 0.5, -175)
Main.BackgroundColor3 = COLORS.Background
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.Parent = ScreenGui

-- Window Corner Radius
local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = Main

-- Top Bar (Title Bar)
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 30)
TopBar.BackgroundColor3 = COLORS.TopBar
TopBar.BorderSizePixel = 0
TopBar.Parent = Main

local TopBarCorner = Instance.new("UICorner")
TopBarCorner.CornerRadius = UDim.new(0, 10)
TopBarCorner.Parent = TopBar

-- Traffic Light Buttons
local function CreateCircleButton(color, position)
    local Button = Instance.new("Frame")
    Button.Size = UDim2.new(0, 12, 0, 12)
    Button.Position = position
    Button.BackgroundColor3 = color
    Button.BorderSizePixel = 0
    Button.Parent = TopBar
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(1, 0)
    ButtonCorner.Parent = Button
    
    return Button
end

-- Close, Minimize, Maximize buttons
local CloseButton = CreateCircleButton(COLORS.Red, UDim2.new(0, 10, 0.5, -6))
local MinimizeButton = CreateCircleButton(COLORS.Yellow, UDim2.new(0, 30, 0.5, -6))
local MaximizeButton = CreateCircleButton(COLORS.Green, UDim2.new(0, 50, 0.5, -6))

-- Title
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, -120, 1, 0)
Title.Position = UDim2.new(0, 70, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "macOS App"
Title.TextColor3 = COLORS.Text
Title.TextSize = 13
Title.Font = Enum.Font.SFDisplay
Title.TextXAlignment = Enum.TextXAlignment.Center
Title.Parent = TopBar

-- Sidebar
local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 150, 1, -30)
Sidebar.Position = UDim2.new(0, 0, 0, 30)
Sidebar.BackgroundColor3 = COLORS.Secondary
Sidebar.BorderSizePixel = 0
Sidebar.Parent = Main

-- Tab Container
local TabContainer = Instance.new("ScrollingFrame")
TabContainer.Name = "TabContainer"
TabContainer.Size = UDim2.new(1, -10, 1, -10)
TabContainer.Position = UDim2.new(0, 5, 0, 5)
TabContainer.BackgroundTransparency = 1
TabContainer.ScrollBarThickness = 0
TabContainer.Parent = Sidebar

local TabListLayout = Instance.new("UIListLayout")
TabListLayout.Padding = UDim.new(0, 5)
TabListLayout.Parent = TabContainer

-- Content Area
local Content = Instance.new("Frame")
Content.Name = "Content"
Content.Size = UDim2.new(1, -160, 1, -40)
Content.Position = UDim2.new(0, 155, 0, 35)
Content.BackgroundColor3 = COLORS.Background
Content.BorderSizePixel = 0
Content.Parent = Main

-- Function to create tab buttons
local function CreateTab(name)
    local TabButton = Instance.new("TextButton")
    TabButton.Size = UDim2.new(1, 0, 0, 30)
    TabButton.BackgroundTransparency = 1
    TabButton.Text = name
    TabButton.TextColor3 = COLORS.TextDark
    TabButton.TextSize = 13
    TabButton.Font = Enum.Font.SFDisplay
    TabButton.TextXAlignment = Enum.TextXAlignment.Left
    TabButton.Parent = TabContainer
    
    local Padding = Instance.new("UIPadding")
    Padding.PaddingLeft = UDim.new(0, 10)
    Padding.Parent = TabButton
    
    return TabButton
end

-- Function to create buttons
local function CreateButton(text, parent)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, -20, 0, 32)
    Button.Position = UDim2.new(0, 10, 0, #parent:GetChildren() * 40)
    Button.BackgroundColor3 = COLORS.Secondary
    Button.BorderSizePixel = 0
    Button.Text = text
    Button.TextColor3 = COLORS.Text
    Button.TextSize = 13
    Button.Font = Enum.Font.SFDisplay
    Button.Parent = parent
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 6)
    ButtonCorner.Parent = Button
    
    -- Hover Effect
    Button.MouseEnter:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.2), {
            BackgroundColor3 = COLORS.ButtonHover
        }):Play()
    end)
    
    Button.MouseLeave:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.2), {
            BackgroundColor3 = COLORS.Secondary
        }):Play()
    end)
    
    return Button
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

-- Example usage
local GeneralTab = CreateTab("General")
local SettingsTab = CreateTab("Settings")

-- Create content pages
local GeneralPage = Instance.new("Frame")
GeneralPage.Size = UDim2.new(1, 0, 1, 0)
GeneralPage.BackgroundTransparency = 1
GeneralPage.Visible = true
GeneralPage.Parent = Content

local SettingsPage = Instance.new("Frame")
SettingsPage.Size = UDim2.new(1, 0, 1, 0)
SettingsPage.BackgroundTransparency = 1
SettingsPage.Visible = false
SettingsPage.Parent = Content

-- Add some buttons
CreateButton("Option 1", GeneralPage)
CreateButton("Option 2", GeneralPage)
CreateButton("Settings 1", SettingsPage)
CreateButton("Settings 2", SettingsPage)

-- Tab switching logic
local function SwitchTab(button, page)
    for _, tab in pairs(TabContainer:GetChildren()) do
        if tab:IsA("TextButton") then
            tab.TextColor3 = COLORS.TextDark
        end
    end
    button.TextColor3 = COLORS.Accent
    
    for _, p in pairs(Content:GetChildren()) do
        p.Visible = false
    end
    page.Visible = true
end

GeneralTab.MouseButton1Click:Connect(function()
    SwitchTab(GeneralTab, GeneralPage)
end)

SettingsTab.MouseButton1Click:Connect(function()
    SwitchTab(SettingsTab, SettingsPage)
end)

-- Show first tab by default
SwitchTab(GeneralTab, GeneralPage)
