-- vim: set et hlsearch ts=4 sts=4 sw=4:

local widget = require("widgets/widget")

-- A container of widgets that supports various methods that get applied to all subwidgets.
-- Subwidgets are added bottom-up, the latest ones are drawn last and checked for clicks first
local WidgetContainer = {
    __name = "WidgetContainer",
    __subwidgets = nil,
    x = 0,
    y = 0,
    w = 800,
    h = 600}

setmetatable(WidgetContainer, widget)

function WidgetContainer.__index(table, key)
    return WidgetContainer[key] or (getmetatable(WidgetContainer) or {})[key]
end

function WidgetContainer.add(self, widget)
    widget.parent_widget = self
    table.insert(self.__subwidgets, widget)
end

function WidgetContainer.subwidgets(self)
    local index = 1
    return function()
        local widget = self.__subwidgets[index]
        if widget and widget.__dead then
            table.remove(self.__subwidgets, index)
            widget = self.__subwidgets[index]
        end
        index = index + 1
        return widget
    end
end

function WidgetContainer.reverseSubwidgets(self)
    local index = #self.__subwidgets
    return function()
        local widget = self.__subwidgets[index]
        index = index - 1
        return widget
    end
end

function WidgetContainer.update(self, dt)
    for widget in self:subwidgets() do
        if widget.update then
            widget:update(dt)
        end
    end
end

function WidgetContainer.draw(self)
    love.graphics.push()
    love.graphics.translate(self.x, self.y)
    if self.fill then
        love.graphics.setColor(self.fill)
        love.graphics.rectangle("fill", 0, 0, self.w, self.h)
    end
    if self.line then
        love.graphics.setColor(self.line)
        love.graphics.rectangle("line", 0, 0, self.w, self.h)
    end
    for widget in self:subwidgets() do
        if widget.draw then
            widget:draw()
        end
    end
    love.graphics.pop()
end

function WidgetContainer.mousepressed(self, x, y, button, istouch, presses)
    if self:isPointInside(x, y) then
        local subx = x - self.x
        local suby = y - self.y
        for widget in self:reverseSubwidgets() do
            if widget:isPointInside(subx, suby) and widget.mousepressed then
                widget:mousepressed(subx, suby, button, istouch, presses)
                break
            end
        end
    end
end

function WidgetContainer.mousereleased(self, x, y, button, istouch, presses)
    if self:isPointInside(x, y) then
        local subx = x - self.x
        local suby = y - self.y
        for widget in self:reverseSubwidgets() do
            if widget:isPointInside(subx, suby) and widget.mousereleased then
                widget:mousereleased(subx, suby, button, istouch, presses)
                break
            end
        end
    end
end

function WidgetContainer.WidgetContainer(obj, subwidgets)
    if not obj then
        obj = {}
    end
    if not subwidgets then
        subwidgets = {}
    end
    obj.__subwidgets = subwidgets
    setmetatable(obj, WidgetContainer)
    return obj
end

return WidgetContainer
