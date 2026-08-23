-- Path: Altis-DEV/MyLibrary/Init.lua

local BaseURL =
    "https://raw.githubusercontent.com/Altis-DEV/MyLibrary/refs/heads/main/"


local function Notify(msg)

    warn("[Altis Library] "..msg)

    if game:GetService("StarterGui") then
        pcall(function()
            game:GetService("StarterGui"):SetCore(
                "SendNotification",
                {
                    Title = "Altis Library",
                    Text = msg,
                    Duration = 5
                }
            )
        end)
    end

end



local function LoadModule(path)

    local url = BaseURL .. path

    Notify("Loading: "..url)


    local success, result = pcall(function()

        local source = game:HttpGet(url)


        if not source or source == "" then
            error("Empty response")
        end


        local func, err =
            loadstring(source)


        if not func then
            error(
                "loadstring failed: "..tostring(err)
            )
        end


        return func()

    end)



    if not success then

        Notify(
            "Failed: "..path..
            "\n"..tostring(result)
        )

        error(
            "[Altis Library] Module error: "
            ..path..
            "\n"
            ..tostring(result)
        )

    end



    Notify(
        "Loaded: "..path
    )


    return result

end





local Library = {}



local ThemeModule =
    LoadModule(
        "Src/Theme.lua"
    )


if type(ThemeModule) ~= "table" then

    error(
        "Theme.lua must return table"
    )

end



Library.Theme =
    ThemeModule





function Library.CreateWindow(config)

    local WindowModule =
        LoadModule(
            "Src/Window.lua"
        )


    if type(WindowModule) ~= "table" then

        error(
            "Window.lua did not return module table"
        )

    end


    if not WindowModule.new then

        error(
            "Window.lua missing .new function"
        )

    end



    return WindowModule.new(
        config,
        Library.Theme
    )

end




Notify("Library initialized successfully")


return Library
