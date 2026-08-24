-- Init.lua
local IrisUI = {}

local BaseURL = "https://raw.githubusercontent.com/Altis-DEV/MyLibrary/refs/heads/main/"

-- Hàm LoadModule được viết lại an toàn tuyệt đối
local function LoadModule(path)
    local url = BaseURL .. path
    
    local success, response = pcall(function()
        return game:HttpGet(url)
    end)
    
    if not success then
        error("\n[Iris UI - Lỗi Mạng]: Không thể fetch url: " .. tostring(url) .. "\nLý do: " .. tostring(response))
    end

    -- Bắt lỗi 404 nếu file chưa được push lên Github hoặc sai đường dẫn
    if response == "404: Not Found" or response:match("404") then
        error("\n[Iris UI - Lỗi 404]: File KHÔNG TỒN TẠI trên GitHub tại:\n" .. path .. "\n-> Vui lòng kiểm tra lại bạn đã Push file lên GitHub chưa hoặc sai chữ Hoa/Thường!")
    end
    
    -- Kiểm tra lỗi cú pháp
    local func, compileError = loadstring(response)
    if not func then
        error("\n[Iris UI - Lỗi Cú Pháp]: Có lỗi syntax trong file: " .. path .. "\nChi tiết: " .. tostring(compileError))
    end
    
    -- Chạy file
    local runSuccess, runResult = pcall(func)
    if not runSuccess then
        error("\n[Iris UI - Lỗi Thực Thi]: File " .. path .. " gặp lỗi khi chạy:\n" .. tostring(runResult))
    end
    
    return runResult
end

-- Tải các Modules cơ bản (Nếu lỗi, script sẽ tự động dừng và báo đỏ)
local Theme = LoadModule("Src/Theme.lua")
local WindowEngine = LoadModule("Src/Window.lua")
local TabEngine = LoadModule("Src/Tab.lua")
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
        
        function TabObject:CreateButton(btnConfig)
            return ButtonEngine(Theme, WindowObject, TabObject, btnConfig, ButtonMethod)
        end
        
        return TabObject
    end
    
    return WindowObject
end

return IrisUI
