--Libraries
Object = require "libraries..classic"
HC = require "libraries..HC"
--Classes
require "classes..game"

--Debug
debug = true

function love.load()
  game = Game()
end

function love.update(dt)
  game.update(game, dt)
end

function love.draw()
  game.draw(game)
end
