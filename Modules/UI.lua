-- UI.lua
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local UI = {}

function UI:CreateSidebar(Config)
    local player = Players.LocalPlayer
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "UniversalH4x_UI"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = player:WaitForChild("PlayerGui")

    local accentColor = Color3.fromRGB(255, 55, 65)
    local bgMainColor = Color3.fromRGB(10, 10, 14)
    local bgCardColor = Color3.fromRGB(18, 18, 24)
    local textPrimary = Color3.fromRGB(245, 245, 250)
    local textSecondary = Color3.fromRGB(150, 150, 165)

    local function getConfig(key, default)
        return (Config and Config[key] ~= nil) and Config[key] or default
    end

    -- Floating Main Toggle Button
    local toggleBtn = Instance.new("ImageButton")
    toggleBtn.Size = UDim2.new(0, 40, 0, 40)
    toggleBtn.Position = UDim2.new(0, 20, 0, 20)
    toggleBtn.BackgroundColor3 = bgMainColor
    toggleBtn.BackgroundTransparency = 0.2
    toggleBtn.Image = "rbxassetid://6031090793"
    toggleBtn.ImageColor3 = accentColor
    toggleBtn.Parent = screenGui
    Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 10)

    -- ==========================================
    -- MOBILE HOLD AIM BUTTON (Android Only Feature)
    -- ==========================================
    local isMobile = UserInputService.TouchEnabled
    local mobileAimBtn

    if isMobile then
        mobileAimBtn = Instance.new("TextButton")
        mobileAimBtn.Name = "MobileAimButton"
        mobileAimBtn.Size = UDim2.new(0, 65, 0, 65)
        mobileAimBtn.Position = UDim2.new(1, -90, 0.5, -32)
        mobileAimBtn.BackgroundColor3 = bgMainColor
        mobileAimBtn.BackgroundTransparency = 0.3
        mobileAimBtn.Text = "AIM"
        mobileAimBtn.TextColor3 = accentColor
        mobileAimBtn.TextSize = 14
        mobileAimBtn.Font = Enum.Font.GothamBold
        mobileAimBtn.Parent = screenGui
        Instance.new("UICorner", mobileAimBtn).CornerRadius = UDim.new(1, 0)

        local aimStroke = Instance.new("UIStroke", mobileAimBtn)
        aimStroke.Color = accentColor
        aimStroke.Thickness = 2

        -- Hold Logic Mobile
        mobileAimBtn.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch then
                _G.MobileAimHolding = true
                TweenService:Create(mobileAimBtn, TweenInfo.new(0.1), {BackgroundColor3 = accentColor, TextColor3 = Color3.fromRGB(255,255,255)}):Play()
            end
        end)

        mobileAimBtn.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch then
                _G.MobileAimHolding = false
                TweenService:Create(mobileAimBtn, TweenInfo.new(0.1), {BackgroundColor3 = bgMainColor, TextColor3 = accentColor}):Play()
            end
        end)
    end

    -- Main Window Setup
    local mainWindow = Instance.new("Frame")
    mainWindow.Size = UDim2.new(0, 520, 0, 320)
    mainWindow.Position = UDim2.new(0.5, -260, 0.5, -160)
    mainWindow.BackgroundColor3 = bgMainColor
    mainWindow.BackgroundTransparency = 0.25
    mainWindow.ClipsDescendants = true
    mainWindow.Parent = screenGui
    Instance.new("UICorner", mainWindow).CornerRadius = UDim.new(0, 12)

    toggleBtn.MouseButton1Click:Connect(function()
        mainWindow.Visible = not mainWindow.Visible
    end)

    -- Window Dragging System
    local dragging, dragStart, startPos
    mainWindow.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = mainWindow.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            mainWindow.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    -- Sidebar & Content Construction
    local sidebar = Instance.new("Frame")
    sidebar.Size = UDim2.new(0, 140, 1, 0)
    sidebar.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
    sidebar.BackgroundTransparency = 0.3
    sidebar.Parent = mainWindow

    local navContainer = Instance.new("Frame")
    navContainer.Size = UDim2.new(1, 0, 1, -40)
    navContainer.Position = UDim2.new(0, 0, 0, 40)
    navContainer.Parent = sidebar

    local navLayout = Instance.new("UIListLayout")
    navLayout.Padding = UDim.new(0, 4)
    navLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    navLayout.Parent = navContainer

    local contentArea = Instance.new("Frame")
    contentArea.Size = UDim2.new(1, -140, 1, 0)
    contentArea.Position = UDim2.new(0, 140, 0, 0)
    contentArea.BackgroundTransparency = 1
    contentArea.Parent = mainWindow

    local tabs = {}
    local navButtons = {}

    local function SwitchTab(tabName)
        for name, tab in pairs(tabs) do tab.Visible = (name == tabName) end
        for name, btn in pairs(navButtons) do
            btn.TextColor3 = (name == tabName) and textPrimary or textSecondary
            btn.BackgroundColor3 = (name == tabName) and accentColor or bgCardColor
            btn.BackgroundTransparency = (name == tabName) and 0.8 or 1
        end
    end

    local function CreateNavButton(name, icon)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -12, 0, 30)
        btn.BackgroundColor3 = bgCardColor
        btn.BackgroundTransparency = 1
        btn.Text = icon .. " " .. name
        btn.TextColor3 = textSecondary
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 11
        btn.Parent = navContainer
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

        navButtons[name] = btn
        btn.MouseButton1Click:Connect(function() SwitchTab(name) end)
    end

    local function CreateTab(name)
        local scroll = Instance.new("ScrollingFrame")
        scroll.Size = UDim2.new(1, -20, 1, -20)
        scroll.Position = UDim2.new(0, 10, 0, 10)
        scroll.BackgroundTransparency = 1
        scroll.ScrollBarThickness = 2
        scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
        scroll.Visible = false
        scroll.Parent = contentArea

        local layout = Instance.new("UIListLayout")
        layout.Padding = UDim.new(0, 6)
        layout.Parent = scroll

        tabs[name] = scroll
        return scroll
    end

    local function createCard(parent)
        local card = Instance.new("Frame")
        card.Size = UDim2.new(1, 0, 0, 0)
        card.AutomaticSize = Enum.AutomaticSize.Y
        card.BackgroundColor3 = bgCardColor
        card.BackgroundTransparency = 0.45
        card.Parent = parent
        Instance.new("UICorner", card).CornerRadius = UDim.new(0, 6)

        local layout = Instance.new("UIListLayout")
        layout.Padding = UDim.new(0, 6)
        layout.Parent = card

        local padding = Instance.new("UIPadding")
        padding.PaddingTop = UDim.new(0, 8)
        padding.PaddingBottom = UDim.new(0, 8)
        padding.PaddingLeft = UDim.new(0, 8)
        padding.PaddingRight = UDim.new(0, 8)
        padding.Parent = card

        return card
    end

    local function createToggle(card, text, key)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 0, 24)
        frame.BackgroundTransparency = 1
        frame.Parent = card

        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(0.7, 0, 1, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = text
        lbl.TextColor3 = textPrimary
        lbl.Font = Enum.Font.GothamSemibold
        lbl.TextSize = 11
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = frame

        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 36, 0, 18)
        btn.Position = UDim2.new(1, -36, 0.5, -9)
        btn.BackgroundColor3 = getConfig(key, false) and accentColor or Color3.fromRGB(35, 35, 45)
        btn.Text = ""
        btn.Parent = frame
        Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)

        btn.MouseButton1Click:Connect(function()
            Config[key] = not getConfig(key, false)
            btn.BackgroundColor3 = Config[key] and accentColor or Color3.fromRGB(35, 35, 45)
        end)
    end

    local function createDropdown(card, text, key, options)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 0, 28)
        frame.BackgroundTransparency = 1
        frame.Parent = card

        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(0.5, 0, 1, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = text
        lbl.TextColor3 = textPrimary
        lbl.Font = Enum.Font.GothamSemibold
        lbl.TextSize = 11
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = frame

        local dropBtn = Instance.new("TextButton")
        dropBtn.Size = UDim2.new(0.45, 0, 1, 0)
        dropBtn.Position = UDim2.new(0.55, 0, 0, 0)
        dropBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
        dropBtn.Text = tostring(getConfig(key, options[1]))
        dropBtn.TextColor3 = accentColor
        dropBtn.Font = Enum.Font.GothamBold
        dropBtn.TextSize = 10
        dropBtn.Parent = frame
        Instance.new("UICorner", dropBtn).CornerRadius = UDim.new(0, 4)

        local currentIdx = 1
        dropBtn.MouseButton1Click:Connect(function()
            currentIdx = currentIdx % #options + 1
            Config[key] = options[currentIdx]
            dropBtn.Text = options[currentIdx]
        end)
    end

    local function createSlider(card, text, key, minVal, maxVal, step)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 0, 32)
        frame.BackgroundTransparency = 1
        frame.Parent = card

        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(0.6, 0, 0, 14)
        lbl.BackgroundTransparency = 1
        lbl.Text = text
        lbl.TextColor3 = textPrimary
        lbl.Font = Enum.Font.GothamSemibold
        lbl.TextSize = 11
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = frame

        local valLbl = Instance.new("TextLabel")
        valLbl.Size = UDim2.new(0.4, 0, 0, 14)
        valLbl.Position = UDim2.new(0.6, 0, 0, 0)
        valLbl.BackgroundTransparency = 1
        valLbl.Text = tostring(getConfig(key, minVal))
        valLbl.TextColor3 = accentColor
        valLbl.Font = Enum.Font.GothamBold
        valLbl.TextSize = 11
        valLbl.TextXAlignment = Enum.TextXAlignment.Right
        valLbl.Parent = frame

        local sliderBtn = Instance.new("TextButton")
        sliderBtn.Size = UDim2.new(1, 0, 0, 5)
        sliderBtn.Position = UDim2.new(0, 0, 0, 20)
        sliderBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
        sliderBtn.Text = ""
        sliderBtn.Parent = frame
        Instance.new("UICorner", sliderBtn).CornerRadius = UDim.new(1, 0)

        local fill = Instance.new("Frame")
        fill.Size = UDim2.new(math.clamp((getConfig(key, minVal) - minVal) / (maxVal - minVal), 0, 1), 0, 1, 0)
        fill.BackgroundColor3 = accentColor
        fill.Parent = sliderBtn
        Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

        local isDragging = false
        sliderBtn.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then isDragging = true end
        end)
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then isDragging = false end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local percent = math.clamp((input.Position.X - sliderBtn.AbsolutePosition.X) / sliderBtn.AbsoluteSize.X, 0, 1)
                local val = math.floor((minVal + (maxVal - minVal) * percent) / step + 0.5) * step
                Config[key] = val
                fill.Size = UDim2.new(percent, 0, 1, 0)
                valLbl.Text = tostring(val)
            end
        end)
    end

    -- Create Navigation Tabs
    CreateNavButton("Aimbot", "🎯")
    CreateNavButton("Visuals", "👁️")
    CreateNavButton("Weapon", "🔫")

    local tabAimbot = CreateTab("Aimbot")
    local tabVisuals = CreateTab("Visuals")
    local tabWeapon = CreateTab("Weapon")

    -- Tab Aimbot Setup
    local cardAim = createCard(tabAimbot)
    createToggle(cardAim, "Enable Aimbot", "AimbotEnabled")
    createDropdown(cardAim, "Lock Target Part", "AimPart", {"Head", "HumanoidRootPart"})
    createSlider(cardAim, "Smoothness", "Smoothness", 0.05, 0.5, 0.05)
    createToggle(cardAim, "Show FOV Circle", "ShowFOV")
    createSlider(cardAim, "FOV Radius", "FOVRadius", 50, 300, 10)

    -- Tab Visuals Setup
    local cardVis = createCard(tabVisuals)
    createToggle(cardVis, "Player ESP Glow", "ESPEnabled")
    createToggle(cardVis, "Show Teammates", "ShowTeam")

    -- Tab Weapon Setup
    local cardWpn = createCard(tabWeapon)
    createToggle(cardWpn, "No Recoil (Camera)", "NoRecoil")
    createToggle(cardWpn, "No Spread / Straight Bullet", "NoSpread")

    SwitchTab("Aimbot")

    UserInputService.InputBegan:Connect(function(input, processed)
        if not processed and input.KeyCode == Enum.KeyCode.Insert then
            mainWindow.Visible = not mainWindow.Visible
        end
    end)

    return screenGui
end

return UI

