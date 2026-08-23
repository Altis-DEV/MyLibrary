-- Init.lua
local IrisUI = {}

local BaseURL = "https://raw.githubusercontent.com/Altis-DEV/MyLibrary/refs/heads/main/"

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

-- Tải các Modules
local Theme = LoadModule("Src/Theme.lua")
if not Theme then return nil end

local WindowEngine = LoadModule("Src/Window.lua")
if not WindowEngine then return nil end

local TabEngine = LoadModule("Src/Tab.lua")
if not TabEngine then return nil end

-- Khởi tạo Engine cốt lõi
local WindowCore = WindowEngine(Theme)
local TabCore = TabEngine(Theme)

function IrisUI:CreateWindow(config)
    local WindowObject = WindowCore.Create(config)
    
    -- Khởi tạo hệ thống quản lý Tab cho Window này
    TabCore.Init(WindowObject)
    
    -- Đính kèm các method tạo component
    function WindowObject:CreateTab(title)
        return TabCore.Create(WindowObject, title)
    end
    
    return WindowObject
end

return IrisUI
