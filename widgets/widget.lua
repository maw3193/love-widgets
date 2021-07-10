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

function Widget.setStencilTest(self)
        love.graphics.setStencilTest("equal", self:getStencilDepth())
end

function Widget.preDraw(self)
    love.graphics.push()
    love.graphics.translate(self.x, self.y)
    if self.use_stencil then
        love.graphics.stencil(function()
                love.graphics.rectangle("fill", 0, 0, self.w, self.h)
            end,
            "increment",
            1,
            true)
    end
    self:setStencilTest()
end

function Widget.postDraw(self)
    if self.use_stencil then
        love.graphics.stencil(function()
                love.graphics.rectangle("fill", 0, 0, self.w, self.h)
            end,
            "decrement",
            1,
            true)
    end
    love.graphics.pop()
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

function Widget.getStencilDepth(self)
    local depth
    if self.use_stencil then
        depth = 1
    else
        depth = 0
    end
    if self.parent_widget then
        depth = depth + self.parent_widget:getStencilDepth()
    end
    return depth
end

return Widget
