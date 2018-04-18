Game = Object:extend()
HC = require "libraries..HC"

require "classes..player"
require "classes..ball"

function Game.new(self)
  --Game vars
  self.gameWidth = love.graphics:getWidth()
  self.gameHeight = love.graphics.getHeight()
  self.paused = true

  --Init player and ball
  self.player = Player(10, self.gameWidth / 2)
  self.ball = Ball()

  --Score vars
  self.playerScore = 0
  self.aiScore = 0

  --Create world bounds for collision detection
  self.worldBounds = {
    top    = HC.rectangle(0, 1, 800, 1),
    bottom = HC.rectangle(0, 599, 800, 1),
    right  = HC.rectangle(0, 1, 1, 600),
    left   = HC.rectangle(799, 0, 1, 600)
  }
end

function Game.update(self, dt)
  --Update the position of player and ball
  self.player.update(self.player, dt)
  if not self.paused then
    self.ball.update(self.ball, dt)
    self.handleBallWorldCollisions(self)
    self.ball.handlePaddleCollisions(self.ball, self.player)
  end

  --Check for world collisions with the player
  self.handlePaddleWorldCollisions(self)

  --End game if escape key is pressed
  if love.keyboard.isDown('escape') then
    love.event.quit()
  elseif love.keyboard.isDown('space') and self.paused then
    self.paused = false
  end
end

function Game.draw(self)
  --Draw player
  self.player.draw(self.player)
  self.ball.draw(self.ball)

  --Draw world bounds
  self.worldBounds.top:draw('line')
  self.worldBounds.bottom:draw('line')
  self.worldBounds.right:draw('line')
  self.worldBounds.left:draw('line')

  --Draw Score for player and AI
  love.graphics.print("Score: "..tostring(self.playerScore), 10, 10)
  love.graphics.print("Score: "..tostring(self.aiScore), 740, 10)

  --Draw FPS Counter
  love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( )), 10, 580)
end

function Game.handlePaddleWorldCollisions(self)
  for shape, delta in pairs(HC.collisions(self.player.collider)) do
    if self.player.collider:collidesWith(self.worldBounds.top) then
      self.player.y = 3
    elseif self.player.collider:collidesWith(self.worldBounds.bottom) then
      self.player.y = love.graphics:getHeight() - self.player.img:getHeight() - 3
    end
  end
end

function Game.handleBallWorldCollisions(self)
  for shape, delta in pairs(HC.collisions(self.ball.collider)) do
    if self.ball.collider:collidesWith(self.worldBounds.left) then
      self.ball.reset(self.ball)
      self.playerScore = self.playerScore + 1
      self.paused = true
    elseif self.ball.collider:collidesWith(self.worldBounds.right) then
      self.ball.reset(self.ball)
      self.aiScore = self.aiScore + 1
      self.paused = true
    elseif self.ball.collider:collidesWith(self.worldBounds.top) or
      self.ball.collider:collidesWith(self.worldBounds.bottom) then
      self.ball.handleWallCollisions(self.ball)
    end
  end
end
