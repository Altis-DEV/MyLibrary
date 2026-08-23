-- Path: Altis-DEV/MyLibrary/Src/Window.lua

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")


local Window = {}
Window.__index = Window



local function Tween(obj,time,prop)

    TweenService:Create(
        obj,
        TweenInfo.new(time,Enum.EasingStyle.Quad),
        prop
    ):Play()

end




function Window.new(config,Theme)

local self=setmetatable({},Window)

config=config or {}


self.Title=config.Title or "Window"
self.Size=config.Size or Vector2.new(500,350)
self.TextAlignment=config.TextAlignment or "Left"
self.Font=config.Font or Enum.Font.Code
self.Theme=Theme

self.Minimized=true



self.Gui=Instance.new("ScreenGui")
self.Gui.Name="AltisImGui"
self.Gui.ResetOnSpawn=false



self.MainFrame=Instance.new("Frame")
self.MainFrame.Size=UDim2.fromOffset(
    self.Size.X,
    self.Size.Y
)

self.MainFrame.Position=
    UDim2.fromScale(.5,.5)

self.MainFrame.AnchorPoint=
    Vector2.new(.5,.5)

self.MainFrame.BackgroundColor3=
    Theme.Background

self.MainFrame.BorderColor3=
    Theme.Border

self.MainFrame.Parent=self.Gui




-- TOPBAR

self.Topbar=Instance.new("Frame")

self.Topbar.Size=
    UDim2.new(1,0,0,25)

self.Topbar.BackgroundColor3=
    Theme.Accent1

self.Topbar.BorderColor3=
    Theme.Border

self.Topbar.Parent=self.MainFrame




-- MINIMIZE

self.Minimize=Instance.new("TextButton")

self.Minimize.Size=
    UDim2.fromOffset(25,25)

self.Minimize.Text="▼"

self.Minimize.Rotation=-90

self.Minimize.BackgroundTransparency=1

self.Minimize.TextColor3=
    Theme.Text

self.Minimize.Font=self.Font

self.Minimize.Parent=self.Topbar




-- CLOSE

self.CloseButton=Instance.new("TextButton")

self.CloseButton.Size=
    UDim2.fromOffset(25,25)

self.CloseButton.Position=
    UDim2.new(1,-25,0,0)

self.CloseButton.Text="X"

self.CloseButton.BackgroundTransparency=1

self.CloseButton.TextColor3=
    Theme.Text

self.CloseButton.Font=self.Font

self.CloseButton.Parent=self.Topbar




-- TITLE

self.TitleFrame=Instance.new("TextLabel")

self.TitleFrame.Size=
    UDim2.new(1,-50,1,0)

self.TitleFrame.Position=
    UDim2.fromOffset(30,0)

self.TitleFrame.BackgroundTransparency=1

self.TitleFrame.Text=self.Title

self.TitleFrame.TextSize=18

self.TitleFrame.TextColor3=
    Theme.Text

self.TitleFrame.Font=self.Font


if self.TextAlignment=="Center" then

self.TitleFrame.TextXAlignment=
    Enum.TextXAlignment.Center

elseif self.TextAlignment=="Right" then

self.TitleFrame.TextXAlignment=
    Enum.TextXAlignment.Right

else

self.TitleFrame.TextXAlignment=
    Enum.TextXAlignment.Left

end


self.TitleFrame.Parent=self.Topbar




-- TAB CONTAINER

self.TabContainer=Instance.new("Frame")

self.TabContainer.Size=
    UDim2.new(1,0,0,25)

self.TabContainer.Position=
    UDim2.fromOffset(0,25)

self.TabContainer.BackgroundColor3=
    Theme.Background

self.TabContainer.BorderColor3=
    Theme.Border

self.TabContainer.Parent=self.MainFrame




-- RESIZE CORNER

self.Resize=Instance.new("TextButton")

self.Resize.Size=
    UDim2.fromOffset(30,30)

self.Resize.Position=
    UDim2.new(1,-30,1,-30)

self.Resize.Text="◢"

self.Resize.Font=self.Font

self.Resize.TextSize=20

self.Resize.BackgroundTransparency=1

self.Resize.TextColor3=
    Theme.Accent2

self.Resize.Parent=self.MainFrame





-- DRAG SYSTEM

local dragging=false
local dragStart
local startPos


self.Topbar.InputBegan:Connect(function(input)

if input.UserInputType==
Enum.UserInputType.MouseButton1
or
input.UserInputType==
Enum.UserInputType.Touch then

dragging=true

dragStart=input.Position

startPos=self.MainFrame.Position

end

end)



self.Topbar.InputChanged:Connect(function(input)

if input.UserInputType==
Enum.UserInputType.MouseMovement
or
input.UserInputType==
Enum.UserInputType.Touch then


input.Changed:Connect(function()

if input.UserInputState==
Enum.UserInputState.Change
and dragging then


local delta=
input.Position-dragStart


self.MainFrame.Position=
UDim2.new(
startPos.X.Scale,
startPos.X.Offset+delta.X,
startPos.Y.Scale,
startPos.Y.Offset+delta.Y
)


end

end)


end

end)


UserInputService.InputEnded:Connect(function(input)

if input.UserInputType==
Enum.UserInputType.MouseButton1
or
input.UserInputType==
Enum.UserInputType.Touch then

dragging=false

end

end)






-- RESIZE SYSTEM

local resizing=false
local resizeStart
local startSize


self.Resize.InputBegan:Connect(function(input)

if input.UserInputType==
Enum.UserInputType.MouseButton1
or
input.UserInputType==
Enum.UserInputType.Touch then


resizing=true

resizeStart=input.Position

startSize=self.MainFrame.AbsoluteSize


end

end)



UserInputService.InputChanged:Connect(function(input)

if resizing and
(
input.UserInputType==
Enum.UserInputType.MouseMovement
or
input.UserInputType==
Enum.UserInputType.Touch
)
then


local delta=
input.Position-resizeStart


self.MainFrame.Size=
UDim2.fromOffset(
math.max(200,startSize.X+delta.X),
math.max(100,startSize.Y+delta.Y)
)


end

end)



UserInputService.InputEnded:Connect(function()

resizing=false

end)






self.Minimize.MouseButton1Click:Connect(function()
self:ToggleMinimize()
end)


self.CloseButton.MouseButton1Click:Connect(function()
self:Destroy()
end)



self.Gui.Parent=game:GetService("CoreGui")


return self

end






function Window:ToggleMinimize()

self.Minimized=
not self.Minimized


local hide=self.Minimized


Tween(
self.Minimize,
0.2,
{
Rotation=
hide and -90 or 0
}
)


Tween(
self.MainFrame,
0.2,
{
Size=
UDim2.fromOffset(
self.Size.X,
hide and 25 or self.Size.Y
)
}
)


self.TabContainer.Visible=
not hide



end






function Window:Open()

self.MainFrame.Visible=true

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

self.MainFrame.Visible=
not self.MainFrame.Visible

end



function Window:SetTitle(t)

self.Title=t
self.TitleFrame.Text=t

end



function Window:Destroy()

self.Gui:Destroy()

end



return Window
