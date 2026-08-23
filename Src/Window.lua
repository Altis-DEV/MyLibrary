-- Path: Altis-DEV/MyLibrary/Src/Window.lua

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")


local Window = {}
Window.__index = Window



local function Tween(obj,time,props)

    TweenService:Create(
        obj,
        TweenInfo.new(
            time,
            Enum.EasingStyle.Quad,
            Enum.EasingDirection.Out
        ),
        props
    ):Play()

end



function Window.new(config,Theme)

    local self = setmetatable({},Window)

    config = config or {}


    self.Title =
        config.Title or "Window"

    self.Size =
        config.Size or Vector2.new(500,350)

    self.Position =
        config.Position

    self.TextAlignment =
        config.TextAlignment or "Left"

    self.Font =
        config.Font or Enum.Font.Code


    self.Theme = Theme


    -- Window starts opened
    self.Minimized = false



    --------------------------------------------------
    -- GUI
    --------------------------------------------------

    self.Gui = Instance.new("ScreenGui")

    self.Gui.Name =
        "AltisImGui"

    self.Gui.ResetOnSpawn = false



    --------------------------------------------------
    -- Main Frame
    --------------------------------------------------

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



    if self.Position then

        self.MainFrame.Position =
            UDim2.fromOffset(
                self.Position.X,
                self.Position.Y
            )

    else

        self.MainFrame.Position =
            UDim2.fromScale(
                0.5,
                0.5
            )

        self.MainFrame.AnchorPoint =
            Vector2.new(
                0.5,
                0.5
            )

    end


    self.MainFrame.Parent =
        self.Gui




    --------------------------------------------------
    -- Topbar
    --------------------------------------------------

    self.Topbar =
        Instance.new("Frame")


    self.Topbar.Size =
        UDim2.new(
            1,
            0,
            0,
            25
        )


    self.Topbar.BackgroundColor3 =
        Theme.Accent1


    self.Topbar.BorderColor3 =
        Theme.Border


    self.Topbar.Parent =
        self.MainFrame




    --------------------------------------------------
    -- Minimize
    --------------------------------------------------

    self.Minimize =
        Instance.new("TextButton")


    self.Minimize.Size =
        UDim2.fromOffset(
            30,
            25
        )


    self.Minimize.Text =
        "▼"


    -- Open state
    self.Minimize.Rotation =
        0


    self.Minimize.BackgroundTransparency =
        1


    self.Minimize.TextColor3 =
        Theme.Text


    self.Minimize.Font =
        self.Font


    self.Minimize.TextSize =
        18


    self.Minimize.Parent =
        self.Topbar





    --------------------------------------------------
    -- Close Button
    --------------------------------------------------

    self.CloseButton =
        Instance.new("TextButton")


    self.CloseButton.Size =
        UDim2.fromOffset(
            30,
            25
        )


    self.CloseButton.Position =
        UDim2.new(
            1,
            -30,
            0,
            0
        )


    self.CloseButton.Text =
        "X"


    self.CloseButton.BackgroundTransparency =
        1


    self.CloseButton.TextColor3 =
        Theme.Text


    self.CloseButton.Font =
        self.Font


    self.CloseButton.TextSize =
        18


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
            -60,
            1,
            0
        )


    self.TitleFrame.Position =
        UDim2.fromOffset(
            30,
            0
        )


    self.TitleFrame.BackgroundTransparency =
        1


    self.TitleFrame.Text =
        self.Title


    self.TitleFrame.TextColor3 =
        Theme.Text


    self.TitleFrame.TextSize =
        18


    self.TitleFrame.Font =
        self.Font



    if self.TextAlignment == "Center" then

        self.TitleFrame.TextXAlignment =
            Enum.TextXAlignment.Center

    elseif self.TextAlignment == "Right" then

        self.TitleFrame.TextXAlignment =
            Enum.TextXAlignment.Right

    else

        self.TitleFrame.TextXAlignment =
            Enum.TextXAlignment.Left

    end



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
            25
        )


    self.TabContainer.Position =
        UDim2.fromOffset(
            0,
            25
        )


    self.TabContainer.BackgroundColor3 =
        Theme.Background


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
            30,
            30
        )


    self.Resize.Position =
        UDim2.new(
            1,
            -30,
            1,
            -30
        )


    self.Resize.Text =
        "◢"


    self.Resize.BackgroundTransparency =
        1


    self.Resize.TextColor3 =
        Theme.Accent1


    self.Resize.TextXAlignment =
        Enum.TextXAlignment.Right


    self.Resize.TextYAlignment =
        Enum.TextYAlignment.Bottom


    self.Resize.Font =
        self.Font


    self.Resize.TextSize =
        22


    self.Resize.Parent =
        self.MainFrame





    --------------------------------------------------
    -- Drag
    --------------------------------------------------

    local dragging = false
    local dragStart
    local startPos



    self.Topbar.InputBegan:Connect(function(input)

        if
            input.UserInputType ==
            Enum.UserInputType.MouseButton1
            or
            input.UserInputType ==
            Enum.UserInputType.Touch
        then

            dragging = true

            dragStart =
                input.Position

            startPos =
                self.MainFrame.Position

        end

    end)



    UserInputService.InputChanged:Connect(function(input)

        if dragging then

            if
                input.UserInputType ==
                Enum.UserInputType.MouseMovement
                or
                input.UserInputType ==
                Enum.UserInputType.Touch
            then

                local delta =
                    input.Position - dragStart


                self.MainFrame.Position =
                    UDim2.new(
                        startPos.X.Scale,
                        startPos.X.Offset + delta.X,
                        startPos.Y.Scale,
                        startPos.Y.Offset + delta.Y
                    )

            end

        end

    end)



    UserInputService.InputEnded:Connect(function(input)

        if
            input.UserInputType ==
            Enum.UserInputType.MouseButton1
            or
            input.UserInputType ==
            Enum.UserInputType.Touch
        then

            dragging = false

        end

    end)






    --------------------------------------------------
    -- Resize (bottom right only)
    --------------------------------------------------

    local resizing = false
    local resizeStart
    local startSize



    self.Resize.InputBegan:Connect(function(input)

        if
            input.UserInputType ==
            Enum.UserInputType.MouseButton1
            or
            input.UserInputType ==
            Enum.UserInputType.Touch
        then

            resizing = true

            resizeStart =
                input.Position


            startSize =
                self.MainFrame.AbsoluteSize

        end

    end)



    UserInputService.InputChanged:Connect(function(input)

        if resizing then


            if
                input.UserInputType ==
                Enum.UserInputType.MouseMovement
                or
                input.UserInputType ==
                Enum.UserInputType.Touch
            then


                local delta =
                    input.Position - resizeStart


                self.MainFrame.Size =
                    UDim2.fromOffset(

                        math.max(
                            300,
                            startSize.X + delta.X
                        ),

                        math.max(
                            300,
                            startSize.Y + delta.Y
                        )

                    )


            end

        end

    end)



    UserInputService.InputEnded:Connect(function(input)

        if
            input.UserInputType ==
            Enum.UserInputType.MouseButton1
            or
            input.UserInputType ==
            Enum.UserInputType.Touch
        then

            resizing = false

        end

    end)





    --------------------------------------------------
    -- Events
    --------------------------------------------------

    self.Minimize.MouseButton1Click:Connect(function()

        if self.Minimized then

            self:Open()

        else

            self:Close()

        end

    end)



    self.CloseButton.MouseButton1Click:Connect(function()

        self:Destroy()

    end)




    self.Gui.Parent =
        game:GetService("CoreGui")



    return self

end





--------------------------------------------------
-- Official ImGui style methods
--------------------------------------------------


function Window:Open()

    if not self.Minimized then
        return
    end


    self.Minimized = false


    self.TabContainer.Visible = true


    self.MainFrame.Size =
        UDim2.fromOffset(
            self.Size.X,
            self.Size.Y
        )


    Tween(
        self.Minimize,
        0.2,
        {
            Rotation = 0
        }
    )

end





function Window:Close()

    if self.Minimized then
        return
    end


    self.Minimized = true


    self.TabContainer.Visible = false


    self.MainFrame.Size =
        UDim2.fromOffset(
            self.Size.X,
            25
        )


    Tween(
        self.Minimize,
        0.2,
        {
            Rotation = -90
        }
    )

end





function Window:Toggle()

    self.Gui.Enabled =
        not self.Gui.Enabled

end





function Window:SetTitle(text)

    self.Title =
        text

    self.TitleFrame.Text =
        text

end





function Window:Destroy()

    self.Gui:Destroy()

end



return Window
