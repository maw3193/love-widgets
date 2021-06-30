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
--- Resizing the window means repositioning a bunch of widgets. DONE
--- Let every widget have a resize method, widgetcontainers implement it differently to windows. DONE

local Window = {
    __name = "Window",
    __theme = Theme.window,
    grabbed = false,
    grab_offset_x = nil,
    grab_offset_y = nil,
    title = nil, -- the name of the window
    close_button = nil, -- reference to the close button for affecting specifically
    title_bar = nil, -- reference to the title bar for affecting specifically
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

function Window.resize(self, width, height)
    WidgetContainer.resize(self, width, height)
    self.title_bar.w = self.w - self.close_button.w
    self.close_button.x = self.w - self.close_button.w
end

function Window.Window(obj, subwidgets)
    obj = WidgetContainer.WidgetContainer(obj, subwidgets)
    setmetatable(obj, Window)

    obj.close_button = Button.Button{
        y = 0,
        rearrange_exempt = true,
        text = "X",
        onReleased = function(self)
            self.parent_widget:kill()
        end,
    }
    obj:add(obj.close_button)
    
    obj.title_bar = Button.Button{
        rearrange_exempt = true,
        text=obj.title or obj.__name,
        x=0,
        y=0,
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
    obj.title_bar.fill = obj.title_bar.pressed_fill
    obj:add(obj.title_bar)
    obj.top_pad = obj.title_bar.h
    obj:resize(obj.w, obj.h)
    --print("New Window padding:", obj.top_pad, obj.left_pad, obj.right_pad, obj.bottom_pad)
    return obj
end

return Window
