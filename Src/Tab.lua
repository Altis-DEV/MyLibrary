-- Src/Tab.lua
return function(Theme)
    local TabModule = {}

    function TabModule.Init(WindowObject)
        WindowObject.Tabs = {}
        WindowObject.ActiveTab = nil

        -- Thiết lập khoảng cách giữa các tab là 5px trong TabContainer
        local layout = WindowObject.TabContainer:FindFirstChildOfClass("UIListLayout")
        if layout then
            layout.Padding = UDim.new(0, 5)
        end
    end

    function TabModule.Create(WindowObject, title)
        title = title or "Tab"

        -- 1. Tạo ElementContainer trong MainFrame (Chiều ngang = 1 scale, Chiều cao = 0)
        local ElementContainer = Instance.new("Frame")
        ElementContainer.Name = "ElementContainer_" .. title
        ElementContainer.Size = UDim2.new(1, 0, 0, 0)
        ElementContainer.BackgroundTransparency = 1
        ElementContainer.Visible = false
        ElementContainer.Parent = WindowObject.MainFrame

        local ElementLayout = Instance.new("UIListLayout")
        ElementLayout.SortOrder = Enum.SortOrder.LayoutOrder
        ElementLayout.Padding = UDim.new(0, 5)
        ElementLayout.Parent = ElementContainer

        -- 2. Tạo Tab Frame/Button trong TabContainer (Cao = 30, Tự co giãn size ngang, MinSize = 30)
        local TabButton = Instance.new("TextButton")
        TabButton.Name = "TabButton_" .. title
        TabButton.Size = UDim2.new(0, 0, 0, 30)
        TabButton.AutomaticSize = Enum.AutomaticSize.X
        TabButton.BackgroundColor3 = Theme.Accent2
        TabButton.BorderSizePixel = 0
        TabButton.Text = ""
        TabButton.AutoButtonColor = false
        TabButton.Parent = WindowObject.TabContainer

        -- Giới hạn kích thước tối thiểu là 30px
        local TabConstraint = Instance.new("UISizeConstraint")
        TabConstraint.MinSize = Vector2.new(30, 30)
        TabConstraint.Parent = TabButton

        -- Viền (Border)
        local TabStroke = Instance.new("UIStroke")
        TabStroke.Color = Theme.Border
        TabStroke.Thickness = 1
        TabStroke.Parent = TabButton

        -- Padding đệm chữ bên trong Tab
        local TabPadding = Instance.new("UIPadding")
        TabPadding.PaddingLeft = UDim.new(0, 8)
        TabPadding.PaddingRight = UDim.new(0, 8)
        TabPadding.Parent = TabButton

        -- Text Label của Tab
        local TabLabel = Instance.new("TextLabel")
        TabLabel.Name = "TabLabel"
        TabLabel.Size = UDim2.new(1, 0, 1, 0)
        TabLabel.BackgroundTransparency = 1
        TabLabel.Text = title
        TabLabel.TextColor3 = Theme.Text2
        TabLabel.Font = WindowObject.Font or Theme.Font
        TabLabel.TextSize = 13
        TabLabel.Parent = TabButton

        -- Thêm vào danh sách TextElements để hỗ trợ method Window:SetFont()
        table.insert(WindowObject.TextElements, TabLabel)

        -- Object lưu giữ thông tin Tab
        local TabObject = {
            Title = title,
            Button = TabButton,
            Container = ElementContainer,
            Label = TabLabel
        }

        -- Method: Chọn Tab
        function TabObject.Select()
            -- Đổi tất cả các Tab khác về trạng thái Unselected (Accent2, Text2, Container ẩn)
            for _, tab in ipairs(WindowObject.Tabs) do
                tab.Button.BackgroundColor3 = Theme.Accent2
                tab.Label.TextColor3 = Theme.Text2
                tab.Container.Visible = false
            end

            -- Kích hoạt Tab hiện tại (Accent1, Text, Container hiện)
            TabButton.BackgroundColor3 = Theme.Accent1
            TabLabel.TextColor3 = Theme.Text
            ElementContainer.Visible = true
            WindowObject.ActiveTab = TabObject
        end

        -- Method: Đổi tên Tab
        function TabObject.SetTitle(newTitle)
            TabObject.Title = tostring(newTitle)
            TabLabel.Text = tostring(newTitle)
        end

        -- Method: Xóa Tab
        function TabObject.Destroy()
            TabButton:Destroy()
            ElementContainer:Destroy()

            -- Xóa khỏi TextElements
            local textIdx = table.find(WindowObject.TextElements, TabLabel)
            if textIdx then table.remove(WindowObject.TextElements, textIdx) end

            -- Xóa khỏi danh sách Tabs của Window
            local tabIdx = table.find(WindowObject.Tabs, TabObject)
            if tabIdx then table.remove(WindowObject.Tabs, tabIdx) end

            -- Nếu Tab đang chọn bị xóa, tự động chọn Tab kế tiếp nếu có
            if WindowObject.ActiveTab == TabObject then
                WindowObject.ActiveTab = nil
                if #WindowObject.Tabs > 0 then
                    local nextIndex = math.min(tabIdx, #WindowObject.Tabs)
                    WindowObject.Tabs[nextIndex].Select()
                end
            end
        end

        -- Sự kiện khi nhấp vào Tab
        TabButton.MouseButton1Click:Connect(function()
            TabObject.Select()
        end)

        table.insert(WindowObject.Tabs, TabObject)

        -- Mặc định tự động chọn Tab đầu tiên được tạo
        if #WindowObject.Tabs == 1 or WindowObject.ActiveTab == nil then
            TabObject.Select()
        end

        return TabObject
    end

    return TabModule
end

