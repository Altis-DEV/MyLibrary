-- Path: Altis-DEV/MyLibrary/Init.lua

local Repo = "Altis-DEV/MyLibrary/"

local function LoadModule(path)
    return loadstring(
        game:HttpGet(
            "https://raw.githubusercontent.com/" ..
            Repo ..
            path
        )
    )()
end


local Library = {}

Library.Theme = LoadModule("Src/Theme.lua")

Library.CreateWindow = function(config)
    local Window = LoadModule("Src/Window.lua")

    return Window.new(config, Library.Theme)
end


return Library
