-- Src/Elements/Button/Button.lua
local TweenService = game:GetService("TweenService")

return function(Theme, WindowObject, TabObject, Config, MethodModule)
    Config = Config or {}
    local Title = Config.Title or "Button"
    local Type = Config.Type or "Default"
    local BaseColor = Config.Color or Theme.Accent1
    local Callback = Config.Callback or function() end
    
    -- Xử lý màu Highlight khi Hover
    local HoverColor
    if not Config.Color then
        HoverColor = Theme.Highlight
    else
        -- Nếu dùng Color custom, tự động tính toán một màu sáng hơn chút để làm Highlight
        local h, s, v = Color3.toHSV(BaseColor)
        HoverColor = Color3.fromHSV(h, s, math.clamp(v + 0.15, 0, 1))
    end

    -- Bật tính năng tự động mở rộng chiều cao cho ElementContainer của Tab
    TabObject.Container.AutomaticSize = Enum.AutomaticSize.Y

    -- Main Button Frame
    local ButtonFrame = Instance.new("TextButton")
    ButtonFrame.Name = "Button_" .. Title
    ButtonFrame.BackgroundColor3 = BaseColor
    ButtonFrame.BorderSizePixel = 0
    ButtonFrame.Text = ""
    ButtonFrame.AutoButtonColor = false
    
    if Type == "Full" then
        -- Full: Trải dài toàn bộ ElementContainer
        ButtonFrame.Size = UDim2.new(1, 0, 0, 30)
    else
        -- Default: Nằm bên trái và co giãn theo độ dài của chữ
        ButtonFrame.Size = UDim2.new(0, 0, 0, 30)
        ButtonFrame.AutomaticSize = Enum.AutomaticSize.X
    end
    ButtonFrame.Parent = TabObject.Container

    -- Giới hạn kích thước tối thiểu
    local SizeConstraint = Instance.new("UISizeConstraint")
    SizeConstraint.MinSize = Vector2.new(30, 30)
    SizeConstraint.Parent = ButtonFrame

    -- Căn lề padding chữ bên trong (cho Default Type)
    local Padding = Instance.new("UIPadding")
    Padding.PaddingLeft = UDim.new(0, 8)
    Padding.PaddingRight = UDim.new(0, 8)
    Padding.Parent = ButtonFrame

    -- Viền ngoài (Border)
    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Theme.Border
    Stroke.Thickness = 1
    Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    Stroke.Parent = ButtonFrame

    -- Label hiển thị tên Button
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "TitleLabel"
    TitleLabel.Size = UDim2.new(1, 0, 1, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = Title
    TitleLabel.TextColor3 = Theme.Text
    TitleLabel.Font = WindowObject.Font or Theme.Font
    TitleLabel.TextSize = 13
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Center
    TitleLabel.Parent = ButtonFrame

    -- Ghi nhận TextLabel vào WindowObject để hỗ trợ hàm SetFont
    table.insert(WindowObject.TextElements, TitleLabel)

    -- Hiệu ứng Hover / Click mượt mà
    ButtonFrame.MouseEnter:Connect(function()
        TweenService:Create(ButtonFrame, TweenInfo.new(0.2), {BackgroundColor3 = HoverColor}):Play()
    end)

    ButtonFrame.MouseLeave:Connect(function()
        TweenService:Create(ButtonFrame, TweenInfo.new(0.2), {BackgroundColor3 = BaseColor}):Play()
    end)

    ButtonFrame.MouseButton1Down:Connect(function()
        TweenService:Create(ButtonFrame, TweenInfo.new(0.1), {BackgroundColor3 = Theme.Accent2}):Play()
    end)

    ButtonFrame.MouseButton1Up:Connect(function()
        TweenService:Create(ButtonFrame, TweenInfo.new(0.1), {BackgroundColor3 = HoverColor}):Play()
    end)

    -- Gọi Callback khi Click
    ButtonFrame.MouseButton1Click:Connect(function()
        Callback()
    end)

    -- Đóng gói Button Object
    local ButtonObject = {
        Title = Title,
        Frame = ButtonFrame,
        Label = TitleLabel,
        Type = Type
    }

    -- Truyền các dữ liệu vào file Method để khởi tạo hàm SetTitle() và Destroy()
    MethodModule(ButtonObject, ButtonFrame, TitleLabel, WindowObject)

    return ButtonObject
end

