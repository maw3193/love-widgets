-- vim: set et hlsearch ts=4 sts=4 sw=4:
local Theme = require("widgets/theme")
local Widget = require("widgets/widget")

local Button = {
    __name = "Button",
    __theme = Theme.button,
    pressed = false,
    text = nil,
}

setmetatable(Button, Widget)

function Button.__index(table, key)
    return Button.__theme[key] or Button[key] or (getmetatable(Button) or {})[key]
end

function Button.mousepressed(self, x, y, button, istouch, presses)
    local subx = x - self.x
    local suby = y - self.y
    --print("Button pressed at", subx, suby)
    self:onPressed(subx, suby)
    self.pressed = true
end

function Button.mousereleased(self, x, y, button, istouch, presses)
    self:onReleased(x - self.x, y - self.y)
    self.pressed = false
end

function Button.onPressed(self, x, y)
end

function Button.onReleased(self, x, y)
end

function Button.draw(self)
    if self.pressed then
        love.graphics.setColor(self.pressed_fill)
    else
        love.graphics.setColor(self.fill)
    end
    love.graphics.rectangle("fill", 0, 0, self.w, self.h)
    love.graphics.setColor(self.line)
    love.graphics.rectangle("line", 0, 0, self.w, self.h)
    if self.text then
        love.graphics.setColor(self.text_color)
        love.graphics.printf(self.text, 0, 0, self.w, "center")
    end
end

function Button.Button(obj)
    obj = obj or {}
    setmetatable(obj, Button)
    return obj
end

return Button
