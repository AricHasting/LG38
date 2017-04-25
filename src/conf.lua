function love.conf(t)
    -- Only put what we need.
    t.identity = nil                    -- The name of the save directory (string)
    t.version = "0.10.2"                -- The LÖVE version this game was made for (string)
    t.console = false                   -- Attach a console (boolean, Windows only)
    t.window.title = "Revenge of the Bugs"         -- The window title (string)
    t.window.icon = nil                 -- Filepath to an image to use as the window's icon (string)
    t.window.width = 800                -- The window width (number)
    t.window.height = 600               -- The window height (number)
    t.window.msaa = 8                   -- The number of samples to use with multi-sampled antialiasing (number)
    io.stdout:setvbuf("no")             -- By default the console in Sublime Text will not display any output, such as print() calls, until the LOVE application has been closed.
end
