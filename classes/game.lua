Game = Object:extend()
HC = require "libraries..HC"

require "classes..player"
require "classes..enemy"
require "classes..ball"

function Game.new(self)
  --Game vars
  self.gameWidth = love.graphics:getWidth()
  self.gameHeight = love.graphics.getHeight()
  self.paused = true

  --Init player and ball
  self.player = Player(10, (self.gameHeight / 2) - 50)
  --self.enemy = Enemy(500, 200)
  self.enemy = Enemy(self.gameWidth - 35, (self.gameHeight / 2) - 50)
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
    self.enemy.update(self.enemy, dt)
    if self.ball.isMovingToAI(self.ball) then
      self.enemy.followBall(self.enemy, dt, self.ball.y)
    else
      self.enemy.goToCenter(self.enemy, dt)
    end
    self.ball.update(self.ball, dt)
    self.handleBallWorldCollisions(self)
    self.ball.handlePaddleCollisions(self.ball, self.player)
    self.ball.handlePaddleCollisions(self.ball, self.enemy)
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
  self.enemy.draw(self.enemy)

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

  if self.paused then
    love.graphics.print("Press 'SPACE' to start", (self.gameWidth / 2) - 50, (self.gameHeight / 2) - 20)
  end
end

function Game.handlePaddleWorldCollisions(self)
  for shape, delta in pairs(HC.collisions(self.player.collider)) do
    if self.player.collider:collidesWith(self.worldBounds.top) then
      self.player.y = 3
    elseif self.player.collider:collidesWith(self.worldBounds.bottom) then
      self.player.y = love.graphics:getHeight() - self.player.img:getHeight() - 3
    end
  end

  --[[for shape, delta in pairs(HC.collisions(self.enemy.collider)) do
    if self.enemy.collider:collidesWith(self.worldBounds.top) then
      self.enemy.y = 3
    elseif self.enemy.collider:collidesWith(self.worldBounds.bottom) then
      self.enemy.y = love.graphics:getHeight() - self.player.img:getHeight() - 3
    end
  end--]]
end

function Game.handleBallWorldCollisions(self)
  for shape, delta in pairs(HC.collisions(self.ball.collider)) do
    if self.ball.collider:collidesWith(self.worldBounds.left) then
      self.player.reset(self.player)
      self.ball.reset(self.ball)
      self.enemy.reset(self.enemy)
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
