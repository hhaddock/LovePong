Ball = Object:extend()
HC = require "libraries..HC"

debug = true

function Ball.new(self)
    self.img = love.graphics.newImage('assets/Ball.png')

    self.speed = 200
    self.angle = math.rad(-180)
  
    self.width = self.img:getWidth()
    self.height = self.img:getHeight()

    self.x = love.graphics.getWidth() / 2
    self.y = love.graphics.getHeight() / 2
    
    self.originX = self.x
    self.originY = self.y

    self.speedX = 0
    self.speedY = 0

    self.collider = HC.circle(self.x + self.width / 2, self.y + self.height / 2, self.width/2)
end

function Ball.update(self, dt)
    --print("speedx = "..self.speedX)

    self.speedX = self.speed * math.cos(self.angle)
    self.speedY = self.speed * math.sin(self.angle)

    self.x = self.x + (self.speedX * dt)
    self.y = self.y + (self.speedY * dt)

    self.collider:moveTo(self.x + self.img:getWidth() / 2, self.y + self.img:getHeight() / 2)
end

function Ball.draw(self)
    love.graphics.draw(self.img, self.x, self.y)
    self.collider:draw('line')
end

function Ball.handleCollisions(self, player)
    if self.y < 0 or self.y + self.height > love.graphics:getHeight() then
        self.angle = self.angle * -1
    elseif self.x < player.x + player.img:getWidth() and self.y + self.height > player.y and self.y < player.y + player.img:getHeight() then
        self.angle = self.angle * 0.5
    end
    -- if wall == 'left' then
    --     self.speedX = self.speedX * -1
    --     self.speedY = self.speedY * -1
    -- else
    --     self.speedX = self.speedX * 1
    --     self.speedY = self.speedY * 1
    -- end
end