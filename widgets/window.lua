-- vim: set et hlsearch ts=4 sts=4 sw=4:
local Theme = require("widgets/theme")
local WidgetContainer = require("widgets/widgetcontainer")
local Button = require("widgets/button")

-- A Window is a widget container with some special logic in it.
-- It has a frame at the very back and a "close" button
-- Later, it will have a draggable title bar

local Window = {
    __name = "Window",
    __theme = Theme.window,
}

setmetatable(Window, WidgetContainer)

function Window.__index(table, key)
    return Window.__theme[key] or Window[key] or (getmetatable(Window) or {})[key]
end

function Window.Window(obj)
    obj = WidgetContainer.WidgetContainer(obj)
    setmetatable(obj, Window)

    local close_button = Button.Button()
    close_button.x = obj.w - close_button.w
    close_button.y = 0
    close_button.onReleased = function(self)
        self.parent_widget:kill()
    end
    obj:add(close_button)

    return obj
end

return Window
