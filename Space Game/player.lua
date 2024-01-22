Player = {}

function Player:load()
    self.x = 216
    self.y = 112
    self.h = 50
    self.w = 30
    self.xVel = 0
    self.yVel = 0
    self.acc = 2000
    self.fric = 1000
    self.gravity = 600
    self.fuel = 500
    self.img = love.graphics.newImage("Sprites/SpaceShip.png")
    world:add(self, self.x - self.w * 0.5, self.y - self.h, self.w, self.h)
    Player:animation()
end

function Player:animation()
    g = anim8.newGrid(16, 30, self.img:getWidth(), self.img:getHeight())
    self.anim = {}
    self.anim['idle'] = anim8.newAnimation(g(1, 1), 0.1)
    self.anim['fly'] = anim8.newAnimation(g("2-3", 1), 0.1)
    self.anim['turnLeft'] = anim8.newAnimation(g("5-6", 1), 0.1)
    self.anim['turnRight'] = anim8.newAnimation(g("9-10", 1), 0.1)
    self:setState('idle')
end

function Player:setState(state)
    if self.state ~= state then
        self.anim.curr = self.anim[state]
        self.anim.curr:gotoFrame(1)

        self.prevState = self.state
        self.state = state
    end
end

function Player:collide(dt)
    local finalX = self.x - self.w * 0.5 + self.xVel * dt
    local finalY = self.y - self.h + self.yVel * dt

    local actualX, actualY, cols, len = world:move(self, finalX, finalY)
    --Collision checking stuff

    self.x = actualX + self.w * 0.5
    self.y = actualY + self.h

    self.grounded = false
    for i = 1, len do
        local other = cols[i]
        if other.other.isWall then
            if other.normal.y == -1 or other.normal.y == 1 then
                self.yVel = 0
            end

            if other.normal.y == -1 then
                self.grounded = true
            else
                self.grounded = false
            end
        end
    end

end

function Player:move(dt)
    if love.keyboard.isScancodeDown('w', 'a', 's', 'd') then
        if self.fuel > 0 then
            if love.keyboard.isScancodeDown("w") then
                self:setState('fly')
                if self.yVel > -800 then
                    self.yVel = self.yVel - self.acc * dt
                end
                self.fuel = self.fuel - 1
            end
        end
        if love.keyboard.isScancodeDown("a") then
            self:setState('turnLeft')
            --currAnim:pauseAtEnd()
            if self.xVel > -800 then
                self.xVel = self.xVel - self.acc * dt
            end
        end
        if love.keyboard.isScancodeDown("d") then
            self:setState('turnRight')
            if self.xVel < 500 then
                self.xVel = self.xVel + self.acc * dt
            end
        end
    else
        self:setState('idle')
        --self.yVel = 0
        self.xVel = 0
    end


end

function Player:appGravity(dt)
    if self.yVel < 1000 then
        self.yVel = self.yVel + self.gravity * dt
    end
end

function Player:update(dt)
    local state = self.state

    if state == 'turnLeft' then
        if self.anim.curr.position == 2 then
            self.anim.curr = anim8.newAnimation(g(6, 1), 0.1)
        end
    elseif state == 'turnRight' then
        if self.anim.curr.position == 2 then
            self.anim.curr = anim8.newAnimation(g(10, 1), 0.1)
        end
    end

    self.anim.curr:update(dt)
    Player:move(dt)
    Player:collide(dt)
    Player:appGravity(dt)
    --self.anim.curr:update(dt)
end

function Player:draw()
    self.anim.curr:draw(self.img, self.x, self.y, nil, 2, 2, 8, 25)
end
