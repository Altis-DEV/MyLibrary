-- Init.lua
local IrisUI = {}

-- Đường dẫn raw tới repo (Bạn nhớ giữ nguyên URL này theo repo của bạn)
local BaseURL = "https://raw.githubusercontent.com/Altis-DEV/MyLibrary/refs/heads/main/"

-- Hàm hỗ trợ tải file từ Github
local function LoadModule(path)
    local url = BaseURL .. path
    local success, result = pcall(function()
        return loadstring(game:HttpGet(url))()
    end)
    
    if not success then
        warn("[Iris UI] Failed to load module: " .. path)
        warn("Error: " .. tostring(result))
        return nil
    end
    
    return result
end

-- Tải Theme mặc định
local Theme = LoadModule("Src/Theme.lua")
if not Theme then return nil end

-- Tải và khởi tạo Window Engine
local WindowEngine = LoadModule("Src/Window.lua")
if not WindowEngine then return nil end

-- Gắn Theme vào Engine
local WindowCore = WindowEngine(Theme)

-- Hàm khởi tạo Window (Entry point cho người dùng)
function IrisUI:CreateWindow(config)
    local WindowObject = WindowCore.Create(config)
    
    -- (Tương lai) Chỗ này sẽ inject các hàm khởi tạo Tab, ElementContainer, Button...
    -- Ví dụ: function WindowObject.AddTab(...) end
    
    return WindowObject
end

return IrisUI
