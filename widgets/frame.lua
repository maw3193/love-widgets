-- vim: set et hlsearch ts=4 sts=4 sw=4:

local Theme = require("widgets/theme")
local Widget = require("widgets/widget")

Frame = {
    __name = "Frame",
    __theme = Theme.frame,
    text = nil,
}

-- XXX: Won't cause confusion so long as I never get functions in Theme.
setmetatable(Frame, Widget)

function Frame.__index(table, key)
    --[[ in order of preference:
         * The object's value
         * The theme's value
         * The class' value
         * Any parent class' value
    --]]
    
    return Frame.__theme[key] or Frame[key] or (getmetatable(Frame) or {})[key]
end

function Frame.draw(self)
    love.graphics.setColor(self.fill)
    love.graphics.rectangle("fill", 0, 0, self.w, self.h)
    love.graphics.setColor(self.line)
    love.graphics.rectangle("line", 0, 0, self.w, self.h)
    if self.text then
        love.graphics.setColor(self.text_color)
        love.graphics.printf(self.text, self.x, self.y, self.w, "center")
    end
end

function Frame.Frame(obj)
    setmetatable(obj, Frame)
    return obj
end

return Frame
