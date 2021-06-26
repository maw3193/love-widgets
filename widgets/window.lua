-- vim: set et hlsearch ts=4 sts=4 sw=4:
local Theme = require("widgets/theme")
local WidgetContainer = require("widgets/widgetcontainer")
local Button = require("widgets/button")

-- A Window is a widget container with some special logic in it.
-- It has a frame at the very back and a "close" button
-- Plus, it has a draggable title bar
-- Some day, it will be resizable with a button at the bottom-right corner.
-- How does resizing work?
--- There is a resize button which will resize the window by clicking and dragging, rendering an outline.
--- Drawing an outline while pressed is easy.
--- Resizing on release when the cursor outside the button is harder. Override the parent widget's onRelease.
--- Resizing the window means repositioning a bunch of widgets.
--- Let every widget have a resize method, widgetcontainers implement it differently to windows.

local Window = {
    __name = "Window",
    __theme = Theme.window,
    grabbed = false,
    grab_offset_x = nil,
    grab_offset_y = nil,
    title = nil, -- the name of the window
}

setmetatable(Window, WidgetContainer)

function Window.__index(table, key)
    return Window.__theme[key] or Window[key] or (getmetatable(Window) or {})[key]
end

function Window.update(self, dt)
    if self.grabbed then
        local posx,posy = love.mouse.getPosition()
        self.x = posx - self.grab_offset_x
        self.y = posy - self.grab_offset_y
    end
    WidgetContainer.update(self, dt)
end

function Window.Window(obj)
    obj = WidgetContainer.WidgetContainer(obj)
    setmetatable(obj, Window)

    local close_button = Button.Button{
        text = "X",
        onReleased = function(self)
            self.parent_widget:kill()
        end,
    }
    close_button.x = obj.w - close_button.w
    close_button.y = 0
    obj:add(close_button)
    
    local title_bar = Button.Button{
        text=obj.title or obj.__name,
        x=0,
        y=0,
        w=obj.w - close_button.w,
        onPressed = function(self)
            local posx,posy = love.mouse.getPosition()
            self.parent_widget.grab_offset_x = posx - self.parent_widget.x
            self.parent_widget.grab_offset_y = posy - self.parent_widget.y
            self.parent_widget.grabbed = true
        end,
        onReleased = function(self)
            self.parent_widget.grabbed = false
        end,
    }
    title_bar.fill = title_bar.pressed_fill
    obj:add(title_bar)

    return obj
end

return Window
