anim8 = require("anim8/anim8")
local bump = require("bump/bump")
local camera = require("STALKER-X-master/Camera")
local Game = require "states/Game"
local Menu = require "states/menu"
love.graphics.setDefaultFilter("nearest", "nearest")
require("player")
local STI = require("sti")
level = require("Maps/LaunchPad")

function levelLoader(level)
    Map = STI(level)
    local objects = level.layers["solids"].objects
    for i = 1, #objects do
        local obj = objects[i]
        obj.isWall = true
        world:add(obj, obj.x, obj.y, obj.width, obj.height)
    end
end

function love.load()
    world = bump.newWorld()
    Player:load()
    levelLoader(level)
    font = love.graphics.newImageFont("Sprites/Imagefont.png", 
                                    " abcdefghijklmnopqrstuvwxyz" ..
                                    "ABCDEFGHIJKLMNOPQRSTUVWXYZ0" ..
                                    "123456789.,!?-+/():;%&`'*#=[]\"")
    love.graphics.setFont(font)
    game = Game()
    menu = Menu()
    menu.loadMenu()
    game:changeGameState("menu")
    first = Player.y
    cam = camera()
    cam.scale = 2
end

function love.update(dt)
    if game.state.running then
        Player:update(dt)
        local second = Player.y
        distance = first - second
        cam:follow(Player.x, Player.y)
        cam:update(dt)
    elseif game.state.menu then
        menu.updateMenu(dt)
    end
end

function adjBackgroundColor()
    local fadeHeight = 1000
    local atmosphericHeight = 10000

    local fade = 1 - math.max(distance - fadeHeight, 0) / (atmosphericHeight - fadeHeight)

    local r = 0 * fade
    local g = 150/255 * fade
    local b = 1 * fade

    love.graphics.setBackgroundColor(r, g, b)
end

function love.draw()
    if game.state.running then
        love.graphics.setFont(font)
        adjBackgroundColor()
        cam:attach()
            Map:drawLayer(Map.layers["tiles"])
            --currAnim:draw(Player.img, Player.x, Player.y, nil, Player.factor * Player.zoom, Player.zoom, 4, 8)
            love.graphics.print("Distance = " .. math.floor(distance) .. " meters", Player.x - 180, Player.y - 140)
            love.graphics.line(Player.x - love.graphics:getWidth() * 0.5, 320, Player.x + love.graphics:getWidth(), 320)
            Player:draw()
        cam:detach()
    elseif game.state.menu then
        menu.drawMenu()
    end
end

function love.mousepressed(x, y, button)
    if game.state.menu then
        if button == 1 then -- Versions prior to 0.10.0 use the MouseConstant 'l'
            for i, value in ipairs(buttons) do
                if ((y > buttons[i].y) and (y < buttons[i].y + leFont:getHeight(buttons[i].text))) and ((x > buttons[i].x - leFont:getWidth(buttons[i].text) / 2) and (x < buttons[i].x + leFont:getWidth(buttons[i].text) / 2)) then
                    game:changeGameState("running")
                end
           end
        end
    end
end