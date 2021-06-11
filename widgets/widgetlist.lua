-- vim: set et hlsearch ts=4 sts=4 sw=4:

local WidgetList = {}

function WidgetList.add(self, widget)
    table.insert(self, widget)
end

function WidgetList.update(self, dt)
    for _,widget in ipairs(self) do
        if widget.update then
            widget:update(dt)
        end
    end
end

function WidgetList.WidgetList(obj)
    if not obj then
        obj = {}
    end
    setmetatable(obj, WidgetList)
    return obj
end

return WidgetList
