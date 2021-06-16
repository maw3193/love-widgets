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
    },
    button = {
        x = 0,
        y = 0,
        w = 16,
        h = 16,
        fill = Color.white,
        pressed_fill = Color.grey,
        line = Color.grey,
        text_color = Color.white,
    },
    window = {
        x = 0,
        y = 0,
        w = 400,
        h = 300,
        fill = Color.white,
        line = Color.grey,
    },
}

function Theme.__index(table, key)
    return Theme[key] or (getmetatable(Theme) or {})[key]
end

return Theme
