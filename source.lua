-- Modern UI Library for Roblox
-- Created by Assistant

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local Library = {}
Library.__index = Library

-- Styling configuration
local COLORS = {
    Background = Color3.fromRGB(30, 30, 35),
    Accent = Color3.fromRGB(65, 105, 225),
    Text = Color3.fromRGB(255, 255, 255),
    Secondary = Color3.fromRGB(45, 45, 50),
    Hover = Color3.fromRGB(55, 55, 60)
}

local TWEEN_INFO = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

function Library.new(title)
    local gui = Instance.new("ScreenGui")
    gui.Name = "ModernUI"
    gui.ResetOnSpawn = false
    
    local main = Instance.new("Frame")
    main.Name = "Main"
    main.Size = UDim2.new(0, 500, 0, 350)
    main.Position = UDim2.new(0.5, -250, 0.5, -175)
    main.BackgroundColor3 = COLORS.Background
    main.BorderSizePixel = 0
    main.Parent = gui
    
    -- Add rounded corners
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = main
    
    -- Add shadow
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    shadow.BackgroundTransparency = 1
    shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    shadow.Size = UDim2.new(1, 30, 1, 30)
    shadow.ZIndex = -1
    shadow.Image = "rbxassetid://5554236805"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.6
    shadow.Parent = main
    
    -- Title bar
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 30)
    titleBar.BackgroundColor3 = COLORS.Secondary
    titleBar.BorderSizePixel = 0
    titleBar.Parent = main
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 8)
    titleCorner.Parent = titleBar
    
    local titleText = Instance.new("TextLabel")
    titleText.Name = "Title"
    titleText.Text = title or "Modern UI"
    titleText.Size = UDim2.new(1, -10, 1, 0)
    titleText.Position = UDim2.new(0, 10, 0, 0)
    titleText.BackgroundTransparency = 1
    titleText.TextColor3 = COLORS.Text
    titleText.TextSize = 16
    titleText.Font = Enum.Font.GothamBold
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.Parent = titleBar
    
    -- Content container
    local container = Instance.new("ScrollingFrame")
    container.Name = "Container"
    container.Size = UDim2.new(1, -20, 1, -40)
    container.Position = UDim2.new(0, 10, 0, 35)
    container.BackgroundTransparency = 1
    container.BorderSizePixel = 0
    container.ScrollBarThickness = 4
    container.ScrollBarImageColor3 = COLORS.Accent
    container.Parent = main
    
    -- Add padding and layout
    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 5)
    padding.PaddingBottom = UDim.new(0, 5)
    padding.Parent = container
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 5)
    layout.Parent = container
    
    -- Make window draggable
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = main.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            main.Position = UDim2.new(
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
    
    local window = setmetatable({
        gui = gui,
        main = main,
        container = container
    }, Library)
    
    -- Parent the ScreenGui
    if RunService:IsStudio() then
        gui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    else
        gui.Parent = game.CoreGui
    end
    
    return window
end

function Library:AddButton(text, callback)
    local button = Instance.new("TextButton")
    button.Name = "Button"
    button.Size = UDim2.new(1, 0, 0, 35)
    button.BackgroundColor3 = COLORS.Secondary
    button.Text = text
    button.TextColor3 = COLORS.Text
    button.TextSize = 14
    button.Font = Enum.Font.Gotham
    button.BorderSizePixel = 0
    button.Parent = self.container
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = button
    
    -- Hover effect
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TWEEN_INFO, {
            BackgroundColor3 = COLORS.Hover
        }):Play()
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TWEEN_INFO, {
            BackgroundColor3 = COLORS.Secondary
        }):Play()
    end)
    
    button.MouseButton1Click:Connect(function()
        if callback then
            callback()
        end
    end)
    
    return button
end

function Library:AddToggle(text, default, callback)
    local toggle = Instance.new("Frame")
    toggle.Name = "Toggle"
    toggle.Size = UDim2.new(1, 0, 0, 35)
    toggle.BackgroundColor3 = COLORS.Secondary
    toggle.BorderSizePixel = 0
    toggle.Parent = self.container
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = toggle
    
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Text = text
    label.Size = UDim2.new(1, -50, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = COLORS.Text
    label.TextSize = 14
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = toggle
    
    local switch = Instance.new("Frame")
    switch.Name = "Switch"
    switch.Size = UDim2.new(0, 40, 0, 20)
    switch.Position = UDim2.new(1, -45, 0.5, -10)
    switch.BackgroundColor3 = default and COLORS.Accent or COLORS.Hover
    switch.BorderSizePixel = 0
    switch.Parent = toggle
    
    local switchCorner = Instance.new("UICorner")
    switchCorner.CornerRadius = UDim.new(1, 0)
    switchCorner.Parent = switch
    
    local indicator = Instance.new("Frame")
    indicator.Name = "Indicator"
    indicator.Size = UDim2.new(0, 16, 0, 16)
    indicator.Position = UDim2.new(default and 1 or 0, default and -18 or 2, 0.5, -8)
    indicator.BackgroundColor3 = COLORS.Text
    indicator.BorderSizePixel = 0
    indicator.Parent = switch
    
    local indicatorCorner = Instance.new("UICorner")
    indicatorCorner.CornerRadius = UDim.new(1, 0)
    indicatorCorner.Parent = indicator
    
    local enabled = default or false
    local function updateToggle()
        enabled = not enabled
        
        TweenService:Create(switch, TWEEN_INFO, {
            BackgroundColor3 = enabled and COLORS.Accent or COLORS.Hover
        }):Play()
        
        TweenService:Create(indicator, TWEEN_INFO, {
            Position = enabled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
        }):Play()
        
        if callback then
            callback(enabled)
        end
    end
    
    toggle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            updateToggle()
        end
    end)
    
    return {
        Frame = toggle,
        SetState = function(state)
            if state ~= enabled then
                updateToggle()
            end
        end,
        GetState = function()
            return enabled
        end
    }
end

function Library:AddSlider(text, min, max, default, callback)
    local slider = Instance.new("Frame")
    slider.Name = "Slider"
    slider.Size = UDim2.new(1, 0, 0, 50)
    slider.BackgroundColor3 = COLORS.Secondary
    slider.BorderSizePixel = 0
    slider.Parent = self.container
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = slider
    
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Text = text
    label.Size = UDim2.new(1, -10, 0, 20)
    label.Position = UDim2.new(0, 10, 0, 5)
    label.BackgroundTransparency = 1
    label.TextColor3 = COLORS.Text
    label.TextSize = 14
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = slider
    
    local value = Instance.new("TextLabel")
    value.Name = "Value"
    value.Text = tostring(default)
    value.Size = UDim2.new(0, 30, 0, 20)
    value.Position = UDim2.new(1, -40, 0, 5)
    value.BackgroundTransparency = 1
    value.TextColor3 = COLORS.Text
    value.TextSize = 14
    value.Font = Enum.Font.Gotham
    value.Parent = slider
    
    local sliderBar = Instance.new("Frame")
    sliderBar.Name = "SliderBar"
    sliderBar.Size = UDim2.new(1, -20, 0, 4)
    sliderBar.Position = UDim2.new(0, 10, 0, 35)
    sliderBar.BackgroundColor3 = COLORS.Hover
    sliderBar.BorderSizePixel = 0
    sliderBar.Parent = slider
    
    local sliderBarCorner = Instance.new("UICorner")
    sliderBarCorner.CornerRadius = UDim.new(1, 0)
    sliderBarCorner.Parent = sliderBar
    
    local fill = Instance.new("Frame")
    fill.Name = "Fill"
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = COLORS.Accent
    fill.BorderSizePixel = 0
    fill.Parent = sliderBar
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = fill
    
    local function updateSlider(input)
        local pos = math.clamp((input.Position.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1)
        local newValue = math.floor(min + (max - min) * pos)
        
        value.Text = tostring(newValue)
        fill.Size = UDim2.new(pos, 0, 1, 0)
        
        if callback then
            callback(newValue)
        end
    end
    
    local dragging = false
    
    sliderBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            updateSlider(input)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            updateSlider(input)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    return slider
end

return Library
