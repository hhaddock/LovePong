Ball = Object:extend()
HC = require "libraries..HC"

debug = true

function Ball.new(self)
    self.img = love.graphics.newImage('assets/Ball.png')

    self.speed = 200
    self.angle = math.rad(-135)

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

function Ball.handleWallCollisions(self)
    self.angle = self.angle * -1
end

function Ball.reset(self)
  self.x = self.originX
  self.y = self.originY
  self.speedX = 0
  self.speedY = 0
  self.collider = HC.circle(self.x + self.width / 2, self.y + self.height / 2, self.width/2)
end

function Ball.handlePaddleCollisions(self, paddle)
  if self.x < love.graphics:getWidth() / 2 and self.speedX < 0 then
    if self.y + self.height > paddle.y and self.y < paddle.y + paddle.height and self.x < paddle.x + paddle.width then
      if self.speedY < 0 then
        self.angle = self.angle / -3
      else
        self.angle = self.angle / 3
      end
    end
  elseif self.x > love.graphics:getWidth() / 2 and self.speedX > 0 then
    if self.y + self.height > paddle.y and self.y < paddle.y + paddle.height and self.x + self.width > paddle.x and self.x < paddle.x then
      if self.speedY < 0 then
        self.angle = self.angle / 3
      else
        self.angle = self.angle / -3
      end
    end
  end
end
