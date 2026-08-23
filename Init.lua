-- Tải các Modules cơ bản
local Theme = LoadModule("Src/Theme.lua")
if not Theme then return nil end

local WindowEngine = LoadModule("Src/Window.lua")
if not WindowEngine then return nil end

local TabEngine = LoadModule("Src/Tab.lua")
if not TabEngine then return nil end

-- TẢI THÊM MODULES ELEMENTS
local ButtonMethod = LoadModule("Src/Elements/Button/Method.lua")
local ButtonEngine = LoadModule("Src/Elements/Button/Button.lua")

-- Khởi tạo Engine cốt lõi
local WindowCore = WindowEngine(Theme)
local TabCore = TabEngine(Theme)

function IrisUI:CreateWindow(config)
    local WindowObject = WindowCore.Create(config)
    TabCore.Init(WindowObject)
    
    function WindowObject:CreateTab(title)
        local TabObject = TabCore.Create(WindowObject, title)
        
        -- KẾ THỪA CÁC HÀM TẠO ELEMENT VÀO TAB
        function TabObject:CreateButton(config)
            return ButtonEngine(Theme, WindowObject, TabObject, config, ButtonMethod)
        end
        
        return TabObject
    end
    
    return WindowObject
end

return IrisUI
