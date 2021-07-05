-- vim: set et hlsearch ts=4 sts=4 sw=4:
local Widgets = require("widgets/widgets")
local widgets = Widgets.WidgetContainer{x=0, y=0, arrange_mode="horizontal"}

function love.load()
    love.window.setTitle("Widget Toolbox")
    love.graphics.setNewFont("unifont-13.0.06.ttf")
    widgets:add(Widgets.Button{
        x = 0,
        y = 0,
        w = 48,
        h = 48,
        text = "New Window",
        rearrange_exempt = true,
        onReleased = function(self)
            widgets:add(Widgets.Window({
                x = 16,
                y = 48,
                title = "Window " .. #widgets.__subwidgets - 1,
                arrange_mode = "horizontal",
            },
			{
                Widgets.Button{
                    w=64,
                    h=64,
                    text="Tall",
                    onReleased = function(self)
                        self.parent_widget:resize(64, 256)
                        print("Resize "..self.parent_widget.title.." to 64x256")
                    end,
                },
                Widgets.Button{
                    w=64,
                    h=64,
                    text="Wide",
                    onReleased = function(self)
                        self.parent_widget:resize(256, 64)
                        print("Resize "..self.parent_widget.title.." to 256x64")
                    end,
                },
                Widgets.Button{
                    w=64,
                    h=64,
                    text="Small",
                    onReleased = function(self)
                        self.parent_widget:resize(192,192)
                        print("Resize "..self.parent_widget.title.." to 192s192")
                    end,
                },
                Widgets.Button{
                    w=64,
                    h=64,
                    text = "Medium",
                    onReleased = function(self)
                        self.parent_widget:resize(320, 240)
                        print("Resize "..self.parent_widget.title.." to 320x240")
                    end,
                },
            }))
        end
    })
    widgets:add(Widgets.Button{
        x = 48,
        y = 0,
        w = 48,
        h = 48,
        text = "Rearrange",
        rearrange_exempt = true,
        onReleased = function(self)
            self.parent_widget:rearrangeSubwidgets()
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
