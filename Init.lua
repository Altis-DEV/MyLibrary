-- Path: Altis-DEV/MyLibrary/Init.lua

local BaseURL =
    "https://raw.githubusercontent.com/Altis-DEV/MyLibrary/refs/heads/main/"


local function LoadModule(path)

    local source = game:HttpGet(
        BaseURL .. path
    )

    return loadstring(source)()

end


local Library = {}


Library.Theme =
    LoadModule("Src/Theme.lua")


function Library.CreateWindow(config)

    local Window =
        LoadModule("Src/Window.lua")

    return Window.new(
        config,
        Library.Theme
    )

end


return Library
