-- vim: set et hlsearch ts=4 sts=4 sw=4:

-- Widget: base class of all widgets for common methods.
-- A bare widget should not be creatable.
local Widget = {
    __name = "Widget",
    x = 0,
    y = 0,
    w = 16,
    h = 16,
}

function Widget.isPointInside(self, x, y)
    return x >= self.x and y >= self.y and x < (self.x + self.w) and y < (self.y + self.h)
end

return Widget
