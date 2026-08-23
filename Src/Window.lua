-- Path: Altis-DEV/MyLibrary/Src/Window.lua


local TweenService = game:GetService("TweenService")


local Window = {}
Window.__index = Window



function Window.new(config,Theme)

    local self = setmetatable({},Window)


    config = config or {}


    self.Title =
        config.Title or "Window"


    self.Size =
        config.Size or Vector2.new(400,300)


    self.Position =
        config.Position


    self.TextAlignment =
        config.TextAlignment or "Left"


    self.Font =
        config.Font or Enum.Font.Code


    self.Theme = Theme


    self.Minimized = false



    self.Gui = Instance.new("ScreenGui")
    self.Gui.Name = "AltisWindow"
    self.Gui.ResetOnSpawn = false



    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Size =
        UDim2.fromOffset(
            self.Size.X,
            self.Size.Y
        )

    self.MainFrame.BackgroundColor3 =
        Theme.Background

    self.MainFrame.BorderColor3 =
        Theme.Border


    self.MainFrame.Parent =
        self.Gui



    if self.Position then

        self.MainFrame.Position =
            UDim2.fromOffset(
                self.Position.X,
                self.Position.Y
            )

    else

        self.MainFrame.Position =
            UDim2.fromScale(
                .5,
                .5
            )

        self.MainFrame.AnchorPoint =
            Vector2.new(.5,.5)

    end



    --------------------------------------------------
    -- Topbar
    --------------------------------------------------

    self.Topbar = Instance.new("Frame")

    self.Topbar.Size =
        UDim2.new(
            1,
            0,
            0,
            20
        )


    self.Topbar.BackgroundColor3 =
        Theme.Accent1


    self.Topbar.BorderColor3 =
        Theme.Border


    self.Topbar.Parent =
        self.MainFrame



    --------------------------------------------------
    -- Minimize button
    --------------------------------------------------

    self.Minimize =
        Instance.new("TextButton")


    self.Minimize.Size =
        UDim2.fromOffset(
            20,
            20
        )


    self.Minimize.BackgroundTransparency = 1

    self.Minimize.TextTransparency = 1

    self.Minimize.Text = "▶"

    self.Minimize.Parent =
        self.Topbar



    --------------------------------------------------
    -- Close button
    --------------------------------------------------

    self.CloseButton =
        Instance.new("TextButton")


    self.CloseButton.Size =
        UDim2.fromOffset(
            20,
            20
        )


    self.CloseButton.Position =
        UDim2.new(
            1,
            -20,
            0,
            0
        )


    self.CloseButton.Text = "X"

    self.CloseButton.BackgroundTransparency = 1

    self.CloseButton.TextColor3 =
        Theme.Text


    self.CloseButton.Parent =
        self.Topbar



    --------------------------------------------------
    -- Title
    --------------------------------------------------

    self.TitleFrame =
        Instance.new("TextLabel")


    self.TitleFrame.Size =
        UDim2.new(
            1,
            -40,
            1,
            0
        )


    self.TitleFrame.Position =
        UDim2.fromOffset(
            20,
            0
        )


    self.TitleFrame.BackgroundTransparency = 1


    self.TitleFrame.Text =
        self.Title


    self.TitleFrame.TextColor3 =
        Theme.Text


    self.TitleFrame.Font =
        self.Font


    self.TitleFrame.TextXAlignment =
        self:GetAlignment()


    self.TitleFrame.Parent =
        self.Topbar



    --------------------------------------------------
    -- Tab Container
    --------------------------------------------------

    self.TabContainer =
        Instance.new("Frame")


    self.TabContainer.Size =
        UDim2.new(
            1,
            0,
            0,
            20
        )


    self.TabContainer.Position =
        UDim2.fromOffset(
            0,
            20
        )


    self.TabContainer.BackgroundColor3 =
        Theme.Accent2


    self.TabContainer.BorderColor3 =
        Theme.Border


    self.TabContainer.Parent =
        self.MainFrame



    --------------------------------------------------
    -- Resize Corner
    --------------------------------------------------

    self.Resize =
        Instance.new("TextButton")


    self.Resize.Size =
        UDim2.fromOffset(
            15,
            15
        )


    self.Resize.Position =
        UDim2.new(
            1,
            -15,
            1,
            -15
        )


    self.Resize.Text = ""


    self.Resize.BackgroundColor3 =
        Theme.Accent1


    self.Resize.Parent =
        self.MainFrame



    self.Minimize.MouseButton1Click:Connect(function()
        self:ToggleMinimize()
    end)


    self.CloseButton.MouseButton1Click:Connect(function()
        self:Destroy()
    end)



    self.Gui.Parent =
        game:GetService("CoreGui")


    return self
end





function Window:GetAlignment()

    if self.TextAlignment == "Right" then

        return Enum.TextXAlignment.Right

    elseif self.TextAlignment == "Center" then

        return Enum.TextXAlignment.Center

    end


    return Enum.TextXAlignment.Left

end





function Window:ToggleMinimize()

    self.Minimized =
        not self.Minimized


    local target =
        self.Minimized and
        0 or
        1


    TweenService:Create(
        self.Minimize,
        TweenInfo.new(.2),
        {
            Rotation =
            self.Minimized and 90 or 0
        }
    ):Play()



    TweenService:Create(
        self.TabContainer,
        TweenInfo.new(.2),
        {
            Size =
            UDim2.new(
                1,
                0,
                0,
                self.Minimized and 0 or 20
            )
        }
    ):Play()



    TweenService:Create(
        self.MainFrame,
        TweenInfo.new(.2),
        {
            Size =
            UDim2.fromOffset(
                self.Size.X,
                self.Minimized and 20 or self.Size.Y
            )
        }
    ):Play()

end





function Window:Open()

    self.MainFrame.Visible = true

    if self.Minimized then
        self:ToggleMinimize()
    end

end




function Window:Close()

    if not self.Minimized then
        self:ToggleMinimize()
    end

end




function Window:Toggle()

    self.MainFrame.Visible =
        not self.MainFrame.Visible

end





function Window:SetTitle(text)

    self.Title = text

    self.TitleFrame.Text =
        text

end




function Window:Destroy()

    self.Gui:Destroy()

end



return Window
