-- vim: set et hlsearch ts=4 sts=4 sw=4:

local Widget = require("widgets/widget")

local WidgetArrangeMode = {
    HORIZONTAL = "horizontal",
    VERTICAL = "vertical",
    NONE = "none",
}

-- A container of widgets that supports various methods that get applied to all subwidgets.
-- Subwidgets are added bottom-up, the latest ones are drawn last and checked for clicks first
local WidgetContainer = {
    __name = "WidgetContainer",
    __subwidgets = nil,
    __mousereleased_override = nil,
    x = 0,
    y = 0,
    w = 800,
    h = 600,
    top_pad = 0, --when arranging, start this many pixels from the topmost edge
    left_pad = 0,
    right_pad = 0,
    bottom_pad = 0,
    arrange_mode = WidgetArrangeMode.NONE,
}

setmetatable(WidgetContainer, Widget)

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
            widget:preDraw()
            widget:draw()
            widget:postDraw()
        end
    end
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
    --print(self.__name, "mousereleased", x, y)
    if self:isPointInside(x, y) then
        local subx = x - self.x
        local suby = y - self.y
        if self.__mousereleased_override then
            self:__mousereleased_override(subx, suby, button, istouch, presses)
        else
            for widget in self:reverseSubwidgets() do
                if widget:isPointInside(subx, suby) and widget.mousereleased then
                    widget:mousereleased(subx, suby, button, istouch, presses)
                    break
                end
            end
        end
    end
end

function WidgetContainer.rearrangeSubwidgets(self)
    --print("Widget Container padding:", self.top_pad, self.left_pad, self.right_pad, self.bottom_pad)
    --print(self.__name, self.arrange_mode)
    if self.arrange_mode == WidgetArrangeMode.HORIZONTAL then
        local px = self.left_pad
        local py = self.top_pad
        local tallestHeight = 0
        for widget in self:subwidgets() do
            if not widget.rearrange_exempt then
                if px + widget.w > self.w - self.right_pad then -- widget would go off the side, new row.
                    px = self.left_pad
                    py = py + tallestHeight
                    tallestHeight = 0
                end
                widget.x = px
                widget.y = py
                px = px + widget.w
                if widget.h > tallestHeight then
                    tallestHeight = widget.h
                end
            end
        end
    elseif self.arrange_mode == WidgetArrangeMode.VERTICAL then
        local px = self.left_pad
        local py = self.top_pad
        local widestWidth = 0
        for widget in self:subwidgets() do
            if not widget.rearrange_exempt then
                if py + widget.h > self.h - self.bottom_pad then -- widget woud go off the bottom, new column.
                    py = self.top_pad
                    px = px + widestWidth
                    widestWidth = 0
                end
                widget.x = px
                widget.y = py
                py = py + widget.h
                if widget.w > widestWidth then
                    widestWidth = widget.w
                end
            end
        end
    elseif self.arrange_mode == WidgetArrangeMode.NONE then
    else
        print(self, "Widget container tried to rearrange subwidgets with unexpected arrange mode '" .. self.arrange_mode .. "'")
        os.exit(1)
    end
end

function WidgetContainer.resize(self, width, height)
    self.w = width
    self.h = height
    self:rearrangeSubwidgets()
end

function WidgetContainer.WidgetContainer(obj, subwidgets)
    if not obj then
        obj = {}
    end
    obj.__subwidgets = {}
    setmetatable(obj, WidgetContainer)
    for _,widget in ipairs(subwidgets or {}) do
        obj:add(widget)
    end
    obj:rearrangeSubwidgets()
    return obj
end

return WidgetContainer
