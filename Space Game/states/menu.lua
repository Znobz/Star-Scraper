function menu()
    return {
        loadMenu = function()
            buttons = {}
            newButton = function(x, y, text, fn)
                return {
                    x = x,
                    y = y,
                    text = text,
                    fn = fn
                }
            end
            img = love.graphics.newImage("Sprites/SpaceTitleScreen.png")
            leFont = love.graphics.newFont("Sprites/StWinterPixel24Regular-w1e72.otf", 60)
            grid = anim8.newGrid(800, 600, img:getWidth(), img:getHeight())
            anim = anim8.newAnimation(grid("1-12", 1), 0.1)
            table.insert(buttons, newButton(
                love.graphics.getWidth() / 2 + 200,
                500,
                "Start",
                function()
                    print("Start Game")
                end
            ))
            love.graphics.setFont(leFont)
        end,
        
        updateMenu = function(dt)
            anim:update(dt)
        end,

        drawMenu = function()
            --love.graphics.print("Example Text", love.graphics.getWidth() / 2 - (font:getWidth("Example Text") / 2), 10)
            love.graphics.draw(img, 0, 0)
            anim:draw(img, 0, 0)
            love.graphics.setColor(1, 1, 1)
            love.graphics.print(buttons[1].text, buttons[1].x - leFont:getWidth(buttons[1].text) / 2, buttons[1].y)
        end
    }

end

return menu