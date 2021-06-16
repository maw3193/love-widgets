-- vim: set et hlsearch ts=4 sts=4 sw=4:
local Widgets = require("widgets/widgets")
local widgets = Widgets.WidgetContainer{x=32, y=32}

function love.load()
    love.window.setTitle("Widget Toolbox")
    widgets:add(Widgets.Window{
        title="Window 1",
    })
    widgets:add(Widgets.Window{
        title="Window 2",
        x=64,
        y=64,
    })
--    widgets:add(Widgets.Frame{x=0, y=0, w=300, h=200})
--    widgets:add(Widgets.Button{x=0,y=200,w=32,h=32})
end

function love.update(dt)
    widgets:update(dt)
end

function love.draw()
    widgets:draw()
end

function love.mousepressed(x, y, button, istouch, presses)
    widgets:mousepressed(x, y, button, istouch, presses)
end

function love.mousereleased(x, y, button, istouch, presses)
    widgets:mousereleased(x, y, button, istouch, presses)
end
