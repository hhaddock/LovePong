Player = Object:extend()
HC = require "libraries..HC"

debug = true

function Player.new(self, x, y)
    self.img = love.graphics.newImage('assets/paddle.png')

    self.x = x
    self.y = y
    self.width = self.img:getWidth()
    self.height = self.img:getHeight()

    self.speed = 200

    self.originX = self.width / 2
    self.originY = self.height / 2

    self.collider = HC.rectangle(self.x, self.y, self.width, self.height)
end

function Player.update(self, dt)
    if love.keyboard.isDown('d') then
        self.y = self.y + (self.speed * dt)
    elseif love.keyboard.isDown('a') then
        self.y = self.y - (self.speed * dt)
    end

    self.collider:moveTo(self.x + self.width / 2, self.y + self.height / 2)
end

function Player.draw(self)
    love.graphics.draw(self.img, self.x, self.y)
    self.collider:draw('line')
end
