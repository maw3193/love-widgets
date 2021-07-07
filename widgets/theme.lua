-- vim: set et hlsearch ts=4 sts=4 sw=4:

local Color = require("widgets/color")

Theme = {
    frame = {
        x = 20,
        y = 20,
        w = 300,
        h = 200,
        fill = Color.white,
        line = Color.grey,
        text_color = Color.white,
        use_stencil = true,
    },
    button = {
        x = 0,
        y = 0,
        w = 16,
        h = 16,
        fill = Color.grey,
        pressed_fill = Color.dark_grey,
        line = Color.white,
        text_color = Color.white,
        use_stencil = true,
    },
    window = {
        x = 0,
        y = 0,
        w = 400,
        h = 300,
        fill = Color.grey,
        line = Color.white,
        use_stencil = true,
    },
}

function Theme.__index(table, key)
    return Theme[key] or (getmetatable(Theme) or {})[key]
end

return Theme
