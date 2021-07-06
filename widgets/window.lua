-- vim: set et hlsearch ts=4 sts=4 sw=4:
local Theme = require("widgets/theme")
local WidgetContainer = require("widgets/widgetcontainer")
local Button = require("widgets/button")

-- A Window is a widget container with some special logic in it.
-- It has a frame at the very back and a "close" button
-- Plus, it has a draggable title bar
-- And, it's resizable with a button at the bottom-right corner.


local Window = {
    __name = "Window",
    __theme = Theme.window,
    grabbed = false,
    grab_offset_x = nil,
    grab_offset_y = nil,
    title = nil, -- the name of the window
    close_button = nil, -- reference to the close button for affecting specifically
    title_bar = nil, -- reference to the title bar for affecting specifically
    reise_button = nil,
    resize_offset_x = nil,
    resize_offset_y = nil,
}

setmetatable(Window, WidgetContainer)

function Window.__index(table, key)
    return Window.__theme[key] or Window[key] or (getmetatable(Window) or {})[key]
end

function Window.draw(self)
    WidgetContainer.draw(self)
    if self.resize_button.pressed then
        local mouseX, mouseY = love.mouse.getPosition()
        local screenX, screenY = self:getScreenPosition()
        -- because of love.graphics.translate, the mouse position is not useful coords to draw yet.
        love.graphics.setColor(self.line)
        love.graphics.rectangle("line", 0, 0, mouseX - screenX + self.resize_offset_x, mouseY - screenY + self.resize_offset_y)
    end
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
    self.resize_button.x = self.w - self.resize_button.w
    self.resize_button.y = self.h - self.resize_button.h
end

function Window.Window(obj, subwidgets)
    obj = WidgetContainer.WidgetContainer(obj, subwidgets)
    setmetatable(obj, Window)

    obj.close_button = Button.Button{
        y = 0,
        rearrange_exempt = true,
        text = "☒",
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

    obj.resize_button = Button.Button{
        rearrange_exempt = true,
        text = "⇲",
        onPressed = function(self, x, y)
            local button = self
            local window = button.parent_widget
            window.resize_offset_x = self.w - x
            window.resize_offset_y = self.h - y
            window.parent_widget.__mousereleased_override = function(self, x, y)
                window:resize(x - window.x + window.resize_offset_x,
                              y - window.y + window.resize_offset_y)
                window.parent_widget.__mousereleased_override = nil
                button.pressed = false
            end
        end,
    }
    obj:add(obj.resize_button)
    obj.right_pad = obj.resize_button.w
    obj.bottom_pad = obj.resize_button.h

    obj:resize(obj.w, obj.h)
    --print("New Window padding:", obj.top_pad, obj.left_pad, obj.right_pad, obj.bottom_pad)
    return obj
end

return Window
