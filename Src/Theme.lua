-- Src/Theme.lua
local Theme = {
    Accent1 = Color3.fromRGB(24, 112, 196),   -- Màu đặc trưng của ImGui
    Accent2 = Color3.fromRGB(15, 75, 135),    -- Màu ImGui tối hơn
    Highlight = Color3.fromRGB(44, 132, 216), -- Màu Accent1 sáng hơn (dùng khi Hover, v.v.)
    Background = Color3.fromRGB(15, 25, 45),  -- Màu nền xanh dương đậm
    Background2 = Color3.fromRGB(25, 40, 70), -- Màu nền sáng hơn Background
    Border = Color3.fromRGB(65, 65, 65),      -- Viền mặc định
    Text = Color3.fromRGB(255, 255, 255),     -- Màu chữ mặc định
    Text2 = Color3.fromRGB(180, 180, 180),    -- Màu chữ tối hơn Text
    Font = Enum.Font.Code                     -- Font Code
}

return Theme
