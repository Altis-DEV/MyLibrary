-- Src/Window.lua
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- Hàm hỗ trợ kéo thả (Drag) cho cả PC & Mobile
local function MakeDraggable(trigger, target)
    local dragging, dragInput, dragStart, startPos

    trigger.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = target.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    trigger.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            target.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- Hàm hỗ trợ thay đổi kích thước (Resize)
local function MakeResizable(trigger, target)
    local dragging, dragInput, dragStart, startSize

    trigger.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startSize = target.Size

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    trigger.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            local newWidth = math.max(200, startSize.X.Offset + delta.X)
            local newHeight = math.max(100, startSize.Y.Offset + delta.Y)
            target.Size = UDim2.new(startSize.X.Scale, newWidth, startSize.Y.Scale, newHeight)
        end
    end)
end

-- Hàm hỗ trợ set Font đa năng
local function ApplyFont(element, fontInput, themeDefault)
    if typeof(fontInput) == "EnumItem" then
        element.Font = fontInput
    elseif type(fontInput) == "string" then
        if string.match(fontInput, "rbxasset") then
            element.FontFace = Font.new(fontInput)
        else
            local success, enumFont = pcall(function() return Enum.Font[fontInput] end)
            if success then
                element.Font = enumFont
            else
                element.Font = themeDefault
            end
        end
    else
        element.Font = themeDefault
    end
end

return function(Theme)
    local Window = {}

    function Window.Create(config)
        config = config or {}
        local titleText = config.Title or "Iris UI Remake"
        local winSize = config.Size or UDim2.new(0, 400, 0, 300)
        local winPos = config.Position or UDim2.fromScale(0.5, 0.5)
        
        local alignMap = {
            Left = Enum.TextXAlignment.Left,
            Right = Enum.TextXAlignment.Right,
            Center = Enum.TextXAlignment.Center
        }
        local textAlign = alignMap[config.TextAlignment] or Enum.TextXAlignment.Left

        -- 1. Khởi tạo ScreenGui và WindowRoot
        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = "Iris_UI"
        screenGui.ResetOnSpawn = false
        screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        
        local success, hui = pcall(function() return gethui() end)
        screenGui.Parent = success and hui or CoreGui

        local WindowRoot = Instance.new("Frame")
        WindowRoot.Name = "WindowRoot"
        WindowRoot.Size = winSize
        WindowRoot.Position = winPos
        WindowRoot.AnchorPoint = Vector2.new(0, 0)
        WindowRoot.BackgroundTransparency = 1
        WindowRoot.ClipsDescendants = true -- Phục vụ cho animation Minimize
        WindowRoot.Parent = screenGui

        local RootLayout = Instance.new("UIListLayout")
        RootLayout.SortOrder = Enum.SortOrder.LayoutOrder
        RootLayout.Parent = WindowRoot

        -- 2. Topbar
        local Topbar = Instance.new("Frame")
        Topbar.Name = "Topbar"
        Topbar.Size = UDim2.new(1, 0, 0, 20)
        Topbar.BackgroundColor3 = Theme.Accent1
        Topbar.BorderSizePixel = 0
        Topbar.LayoutOrder = 1
        Topbar.Parent = WindowRoot

        local TopbarStroke = Instance.new("UIStroke")
        TopbarStroke.Color = Theme.Border
        TopbarStroke.Parent = Topbar

        -- Các thành phần của Topbar
        local MinimizeButton = Instance.new("TextButton")
        MinimizeButton.Name = "MinimizeButton"
        MinimizeButton.Size = UDim2.new(0, 20, 1, 0)
        MinimizeButton.Position = UDim2.new(0, 0, 0, 0)
        MinimizeButton.BackgroundTransparency = 1
        MinimizeButton.Text = "▼"
        MinimizeButton.TextColor3 = Theme.Text
        MinimizeButton.TextSize = 12
        MinimizeButton.Parent = Topbar

        local DestroyButton = Instance.new("TextButton")
        DestroyButton.Name = "DestroyButton"
        DestroyButton.Size = UDim2.new(0, 20, 1, 0)
        DestroyButton.Position = UDim2.new(1, -20, 0, 0)
        DestroyButton.BackgroundTransparency = 1
        DestroyButton.Text = "X"
        DestroyButton.TextColor3 = Theme.Text
        DestroyButton.TextSize = 14
        DestroyButton.Parent = Topbar

        local TitleFrame = Instance.new("Frame")
        TitleFrame.Name = "TitleFrame"
        TitleFrame.Size = UDim2.new(1, -40, 1, 0)
        TitleFrame.Position = UDim2.new(0, 20, 0, 0)
        TitleFrame.BackgroundTransparency = 1
        TitleFrame.Parent = Topbar

        local TitleLabel = Instance.new("TextLabel")
        TitleLabel.Name = "TitleLabel"
        TitleLabel.Size = UDim2.new(1, -10, 1, 0)
        TitleLabel.Position = UDim2.new(0, 5, 0, 0)
        TitleLabel.BackgroundTransparency = 1
        TitleLabel.Text = titleText
        TitleLabel.TextColor3 = Theme.Text
        TitleLabel.TextXAlignment = textAlign
        TitleLabel.TextSize = 13
        TitleLabel.Parent = TitleFrame

        -- 3. TabContainer
        local TabContainer = Instance.new("ScrollingFrame")
        TabContainer.Name = "TabContainer"
        TabContainer.Size = UDim2.new(1, 0, 0, 20)
        TabContainer.BackgroundColor3 = Theme.Background
        TabContainer.BorderSizePixel = 0
        TabContainer.LayoutOrder = 2
        TabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabContainer.AutomaticCanvasSize = Enum.AutomaticSize.X
        TabContainer.ScrollBarThickness = 0 -- Ẩn scrollbar default để nhìn clean hơn
        TabContainer.Parent = WindowRoot

        local TabStroke = Instance.new("UIStroke")
        TabStroke.Color = Theme.Border
        TabStroke.Parent = TabContainer

        local TabLayout = Instance.new("UIListLayout")
        TabLayout.FillDirection = Enum.FillDirection.Horizontal
        TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
        TabLayout.Parent = TabContainer

        -- 4. MainFrame
        local MainFrame = Instance.new("Frame")
        MainFrame.Name = "MainFrame"
        -- Chiều cao = Tổng - (Topbar:20 + TabContainer:20 + DragHandle:5)
        MainFrame.Size = UDim2.new(1, 0, 1, -45) 
        MainFrame.BackgroundColor3 = Theme.Background
        MainFrame.BorderSizePixel = 0
        MainFrame.LayoutOrder = 3
        MainFrame.Parent = WindowRoot

        local MainStroke = Instance.new("UIStroke")
        MainStroke.Color = Theme.Border
        MainStroke.Parent = MainFrame

        -- ResizeCorner (Tam giác vuông ở góc phải dưới của MainFrame)
        local ResizeCorner = Instance.new("TextLabel")
        ResizeCorner.Name = "ResizeCorner"
        ResizeCorner.Size = UDim2.new(0, 15, 0, 15)
        ResizeCorner.Position = UDim2.new(1, 0, 1, 0)
        ResizeCorner.AnchorPoint = Vector2.new(1, 1)
        ResizeCorner.BackgroundTransparency = 1
        ResizeCorner.Text = "◢"
        ResizeCorner.TextColor3 = Theme.Accent1
        ResizeCorner.TextSize = 14
        ResizeCorner.Parent = MainFrame

        -- 5. DragHandle
        local DragWrapper = Instance.new("Frame")
        DragWrapper.Name = "DragWrapper"
        DragWrapper.Size = UDim2.new(1, 0, 0, 5)
        DragWrapper.BackgroundTransparency = 1
        DragWrapper.LayoutOrder = 4
        DragWrapper.Parent = WindowRoot

        local DragHandle = Instance.new("Frame")
        DragHandle.Name = "DragHandle"
        DragHandle.Size = UDim2.new(0, 100, 1, 0)
        DragHandle.Position = UDim2.new(0.5, 0, 0, 0)
        DragHandle.AnchorPoint = Vector2.new(0.5, 0)
        DragHandle.BackgroundColor3 = Theme.Background
        DragHandle.BackgroundTransparency = 0.5
        DragHandle.BorderSizePixel = 0
        DragHandle.Parent = DragWrapper

        -- Kích hoạt Draggable & Resizable
        MakeDraggable(Topbar, WindowRoot)
        MakeDraggable(DragHandle, WindowRoot)
        MakeResizable(ResizeCorner, WindowRoot)

        -- Quản lý Text & Font
        local TextElements = {TitleLabel, MinimizeButton, DestroyButton, ResizeCorner}
        for _, el in ipairs(TextElements) do
            ApplyFont(el, config.Font, Theme.Font)
        end

        -- Logic Minimize
        local isMinimized = false
        local preMinimizeSize = WindowRoot.Size

        local function ToggleMinimize()
            isMinimized = not isMinimized
            if isMinimized then
                preMinimizeSize = WindowRoot.Size
                TweenService:Create(MinimizeButton, TweenInfo.new(0.2), {Rotation = -90}):Play()
                -- Thu gọn kích thước WindowRoot về đúng bằng chiều cao Topbar (20px)
                TweenService:Create(WindowRoot, TweenInfo.new(0.2), {Size = UDim2.new(preMinimizeSize.X.Scale, preMinimizeSize.X.Offset, 0, 20)}):Play()
            else
                TweenService:Create(MinimizeButton, TweenInfo.new(0.2), {Rotation = 0}):Play()
                TweenService:Create(WindowRoot, TweenInfo.new(0.2), {Size = preMinimizeSize}):Play()
            end
        end

        MinimizeButton.MouseButton1Click:Connect(ToggleMinimize)

        -- Logic Destroy
        DestroyButton.MouseButton1Click:Connect(function()
            screenGui:Destroy()
        end)

        -- Trả về Object với các Method
        local WindowObject = {
            MainFrame = MainFrame,
            TabContainer = TabContainer,
            TextElements = TextElements
        }

        function WindowObject.SetTitle(newTitle)
            TitleLabel.Text = tostring(newTitle)
        end

        function WindowObject.SetSize(newSize)
            WindowRoot.Size = newSize
            if not isMinimized then preMinimizeSize = newSize end
        end

        function WindowObject.SetPosition(newPos)
            TweenService:Create(WindowRoot, TweenInfo.new(0.2), {Position = newPos}):Play()
        end

        function WindowObject.SetFont(newFont)
            for _, el in ipairs(WindowObject.TextElements) do
                ApplyFont(el, newFont, Theme.Font)
            end
        end

        function WindowObject.Open()
            if isMinimized then ToggleMinimize() end
        end

        function WindowObject.Close()
            if not isMinimized then ToggleMinimize() end
        end

        function WindowObject.Toggle()
            screenGui.Enabled = not screenGui.Enabled
        end

        function WindowObject.Destroy()
            screenGui:Destroy()
        end

        return WindowObject
    end

    return Window
end

