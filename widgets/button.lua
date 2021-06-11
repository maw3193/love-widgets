-- vim: set et hlsearch ts=4 sts=4 sw=4:
local Theme = require("widgets/theme")
local Widget = require("widgets/widget")

local Button = {
    __name = "Button",
    __theme = Theme.button,
    pressed = false,
}

setmetatable(Button, Widget)

function Button.__index(table, key)
    return Button.__theme[key] or Button[key] or (getmetatable(Button) or {})[key]
end

function Button.mousepressed(self, x, y, button, istouch, presses)
    -- These buttons are binary pressed/released. anything will do.
    self:onPressed()
    self.pressed = true
end

function Button.mousereleased(self, x, y, button, istouch, presses)
     self:onReleased()
    self.pressed = false
end

function Button.onPressed(self)
    print("Button pressed!")
end

function Button.onReleased(self)
    print("Button released!")
end

function Button.draw(self)
    love.graphics.push()
    love.graphics.translate(self.x, self.y)
    if self.pressed then
        love.graphics.setColor(self.pressed_fill)
    else
        love.graphics.setColor(self.fill)
    end
    love.graphics.rectangle("fill", 0, 0, self.w, self.h)
    love.graphics.setColor(self.line)
    love.graphics.rectangle("line", 0, 0, self.w, self.h)
    love.graphics.pop()
end

function Button.Button(obj)
    setmetatable(obj, Button)
    return obj
end

return Button
