-- vim: set et hlsearch ts=4 sts=4 sw=4:

-- Widget: base class of all widgets for common methods.
-- A bare widget should not be creatable.
local Widget = {
    __name = "Widget",
    __dead = false, -- parent widget should remove this ASAP
    parent_widget = nil, -- lua promises that it can handle cyclical data structures
    rearrange_exempt = false, -- ignore this widget when widget containers rearrange subwidgets
    x = 0,
    y = 0,
    w = 16,
    h = 16,
}

function Widget.isPointInside(self, x, y)
    return x >= self.x and y >= self.y and x < (self.x + self.w) and y < (self.y + self.h)
end

function Widget.kill(self)
    self.__dead = true
end

function Widget.resize(self, width, height)
    self.w = width
    self.h = height
end

function Widget.getScreenPosition(self)
    local x = 0
    local y = 0
    if self.parent_widget then
        x, y = self.parent_widget:getScreenPosition()
    end
    x = x + self.x
    y = y + self.y
    return x, y
end

return Widget
