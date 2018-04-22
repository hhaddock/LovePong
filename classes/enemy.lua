Enemy = Object:extend()
HC = require "libraries..HC"
flux = require "libraries..flux"

debug = true

function Enemy.new(self, x, y)
    self.img = love.graphics.newImage('assets/paddle.png')

    self.x = x
    self.y = y
    self.width = self.img:getWidth()
    self.height = self.img:getHeight()

    self.speed = 10
  
    self.originX = self.width / 2
    self.originY = self.height / 2

    self.collider = HC.rectangle(self.x, self.y, self.img:getWidth(), self.img:getHeight())
end

function Enemy.update(self, dt)
    self.collider:moveTo(self.x + self.img:getWidth() / 2, self.y + self.img:getHeight() / 2)
end

function Enemy.draw(self)
    love.graphics.draw(self.img, self.x, self.y)
    self.collider:draw('line')
end

function Enemy.followBall(self, dt, ballY)
    flux.update(dt)

    flux.to(self, 1.7, {x = self.x, y = ballY})
end