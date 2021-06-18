-- vim: set et hlsearch ts=4 sts=4 sw=4:
local Widgets = require("widgets/widgets")
local widgets = Widgets.WidgetContainer{x=0, y=0}

function love.load()
    love.window.setTitle("Widget Toolbox")
    widgets:add(Widgets.Button{
        x = 0,
        y = 0,
        w = 48,
        h = 48,
        text = "New Window",
        onPressed = function(self)
            widgets:add(Widgets.Window{
                x = 16,
                y = 16,
            })
        end
    })
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
