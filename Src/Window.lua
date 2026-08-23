-- Src/Window.lua
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- Logic Drag chuẩn chống dính trên Mobile: Phải giữ chạm trên 0.2s mới bắt đầu kéo
local function MakeDraggable(trigger, target)
    trigger.Active = true
    
    trigger.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            local isDragging = false
            local dragStart = input.Position
            local startPos = target.Position
            
            -- Hẹn giờ 0.2 giây kiểm tra xem người dùng có giữ tay không
            local holdTimer = task.delay(0.2, function()
                isDragging = true
            end)
            
            local connection
            connection = UserInputService.InputChanged:Connect(function(changeInput)
                if changeInput == input and isDragging then
                    local delta = changeInput.Position - dragStart
                    target.Position = UDim2.new(
                        startPos.X.Scale, startPos.X.Offset + delta.X,
                        startPos.Y.Scale, startPos.Y.Offset + delta.Y
                    )
                end
            end)
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    -- Nếu nhấc tay lên trước 0.2s thì hủy lệnh hẹn giờ và ngắt kết nối
                    if holdTimer then
                        task.cancel(holdTimer)
                    end
                    isDragging = false
                    if connection then 
                        connection:Disconnect() 
                    end
                end
            end)
        end
    end)
end

-- Logic Resize giữ nguyên để mượt mà khi kéo góc
local function MakeResizable(trigger, target)
    trigger.Active = true
    trigger.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            local dragStart = input.Position
            local startSize = target.Size
            
            local connection
            connection = UserInputService.InputChanged:Connect(function(changeInput)
                if changeInput == input then
                    local delta = changeInput.Position - dragStart
                    local newWidth = math.max(200, startSize.X.Offset + delta.X)
                    local newHeight = math.max(100, startSize.Y.Offset + delta.Y)
                    target.Size = UDim2.new(startSize.X.Scale, newWidth, startSize.Y.Scale, newHeight)
                end
            end)
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    if connection then connection:Disconnect() end
                end
            end)
        end
    end)
end

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
        WindowRoot.ClipsDescendants = true
        WindowRoot.Parent = screenGui

        local RootLayout = Instance.new("UIListLayout")
        RootLayout.SortOrder = Enum.SortOrder.LayoutOrder
        RootLayout.Parent = WindowRoot

        -- ================= 1. Topbar (Chiều cao 30, ZIndex 10) =================
        local Topbar = Instance.new("Frame")
        Topbar.Name = "Topbar"
        Topbar.Size = UDim2.new(1, 0, 0, 30)
        Topbar.BackgroundColor3 = Theme.Accent1
        Topbar.BorderSizePixel = 0
        Topbar.LayoutOrder = 1
        Topbar.ZIndex = 10
        Topbar.Parent = WindowRoot

        local TopbarStroke = Instance.new("UIStroke")
        TopbarStroke.Color = Theme.Border
        TopbarStroke.Parent = Topbar

        local MinimizeButton = Instance.new("TextButton")
        MinimizeButton.Name = "MinimizeButton"
        MinimizeButton.Size = UDim2.new(0, 30, 1, 0)
        MinimizeButton.Position = UDim2.new(0, 0, 0, 0)
        MinimizeButton.BackgroundTransparency = 1
        MinimizeButton.Text = "▼"
        MinimizeButton.TextColor3 = Theme.Text
        MinimizeButton.TextSize = 14
        MinimizeButton.ZIndex = 10
        MinimizeButton.Parent = Topbar

        local DestroyButton = Instance.new("TextButton")
        DestroyButton.Name = "DestroyButton"
        DestroyButton.Size = UDim2.new(0, 30, 1, 0)
        DestroyButton.Position = UDim2.new(1, -30, 0, 0)
        DestroyButton.BackgroundTransparency = 1
        DestroyButton.Text = "X"
        DestroyButton.TextColor3 = Theme.Text
        DestroyButton.TextSize = 16
        DestroyButton.ZIndex = 10
        DestroyButton.Parent = Topbar

        local TitleFrame = Instance.new("Frame")
        TitleFrame.Name = "TitleFrame"
        TitleFrame.Size = UDim2.new(1, -60, 1, 0)
        TitleFrame.Position = UDim2.new(0, 30, 0, 0)
        TitleFrame.BackgroundTransparency = 1
        TitleFrame.ZIndex = 10
        TitleFrame.Parent = Topbar

        local TitleLabel = Instance.new("TextLabel")
        TitleLabel.Name = "TitleLabel"
        TitleLabel.Size = UDim2.new(1, -10, 1, 0)
        TitleLabel.Position = UDim2.new(0, 5, 0, 0)
        TitleLabel.BackgroundTransparency = 1
        TitleLabel.Text = titleText
        TitleLabel.TextColor3 = Theme.Text
        TitleLabel.TextXAlignment = textAlign
        TitleLabel.TextSize = 14
        TitleLabel.ZIndex = 10
        TitleLabel.Parent = TitleFrame

        -- ================= 2. TabContainer (Chiều cao 30) =================
        local TabContainer = Instance.new("ScrollingFrame")
        TabContainer.Name = "TabContainer"
        TabContainer.Size = UDim2.new(1, 0, 0, 30)
        TabContainer.BackgroundColor3 = Theme.Background
        TabContainer.BorderSizePixel = 0
        TabContainer.LayoutOrder = 2
        TabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabContainer.AutomaticCanvasSize = Enum.AutomaticSize.X
        TabContainer.ScrollBarThickness = 0
        TabContainer.Parent = WindowRoot

        local TabStroke = Instance.new("UIStroke")
        TabStroke.Color = Theme.Border
        TabStroke.Parent = TabContainer

        local TabLayout = Instance.new("UIListLayout")
        TabLayout.FillDirection = Enum.FillDirection.Horizontal
        TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
        TabLayout.Parent = TabContainer

        -- ================= 3. BodyWrapper & MainFrame =================
        local BodyWrapper = Instance.new("Frame")
        BodyWrapper.Name = "BodyWrapper"
        BodyWrapper.Size = UDim2.new(1, 0, 1, -85)
        BodyWrapper.BackgroundTransparency = 1
        BodyWrapper.LayoutOrder = 3
        BodyWrapper.Parent = WindowRoot

        local MainFrame = Instance.new("ScrollingFrame")
        MainFrame.Name = "MainFrame"
        MainFrame.Size = UDim2.new(1, 0, 1, 0) 
        MainFrame.BackgroundColor3 = Theme.Background
        MainFrame.BorderSizePixel = 0
        MainFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        MainFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
        MainFrame.ScrollBarThickness = 4
        MainFrame.ScrollBarImageColor3 = Theme.Border
        MainFrame.Parent = BodyWrapper

        local MainStroke = Instance.new("UIStroke")
        MainStroke.Color = Theme.Border
        MainStroke.Parent = MainFrame

        -- ResizeCorner (ZIndex 9, TextSize 40 chạm sát góc)
        local ResizeCorner = Instance.new("TextLabel")
        ResizeCorner.Name = "ResizeCorner"
        ResizeCorner.Size = UDim2.new(0, 30, 0, 30)
        ResizeCorner.Position = UDim2.new(1, 0, 1, 0)
        ResizeCorner.AnchorPoint = Vector2.new(1, 1)
        ResizeCorner.BackgroundTransparency = 1
        ResizeCorner.Text = "◢"
        ResizeCorner.TextColor3 = Theme.Accent1
        ResizeCorner.TextSize = 40
        ResizeCorner.ZIndex = 9
        ResizeCorner.Parent = BodyWrapper

        -- ================= 4. DragHandle (ZIndex 8, Trục Y = 10, Size X = 200) =================
        local DragWrapper = Instance.new("Frame")
        DragWrapper.Name = "DragWrapper"
        DragWrapper.Size = UDim2.new(1, 0, 0, 25)
        DragWrapper.BackgroundTransparency = 1
        DragWrapper.LayoutOrder = 4
        DragWrapper.Parent = WindowRoot

        local DragHandle = Instance.new("Frame")
        DragHandle.Name = "DragHandle"
        DragHandle.Size = UDim2.new(0, 200, 0, 5)
        DragHandle.Position = UDim2.new(0.5, 0, 0, 10) -- Trục Y = 10
        DragHandle.AnchorPoint = Vector2.new(0.5, 0)
        DragHandle.BackgroundColor3 = Theme.Accent1
        DragHandle.BorderSizePixel = 0
        DragHandle.ZIndex = 8
        DragHandle.Parent = DragWrapper

        -- Kích hoạt hệ thống kéo/thả mới
        MakeDraggable(Topbar, WindowRoot)
        MakeDraggable(DragHandle, WindowRoot)
        MakeResizable(ResizeCorner, WindowRoot)

        local TextElements = {TitleLabel, MinimizeButton, DestroyButton, ResizeCorner}
        for _, el in ipairs(TextElements) do
            ApplyFont(el, config.Font, Theme.Font)
        end

        local isMinimized = false
        local preMinimizeSize = WindowRoot.Size

        local function ToggleMinimize()
            isMinimized = not isMinimized
            if isMinimized then
                preMinimizeSize = WindowRoot.Size
                TweenService:Create(MinimizeButton, TweenInfo.new(0.2), {Rotation = -90}):Play()
                TweenService:Create(WindowRoot, TweenInfo.new(0.2), {Size = UDim2.new(preMinimizeSize.X.Scale, preMinimizeSize.X.Offset, 0, 30)}):Play()
            else
                TweenService:Create(MinimizeButton, TweenInfo.new(0.2), {Rotation = 0}):Play()
                TweenService:Create(WindowRoot, TweenInfo.new(0.2), {Size = preMinimizeSize}):Play()
            end
        end

        MinimizeButton.MouseButton1Click:Connect(ToggleMinimize)

        DestroyButton.MouseButton1Click:Connect(function()
            screenGui:Destroy()
        end)

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
