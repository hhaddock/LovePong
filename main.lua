--Libraries
Object = require "libraries..classic"
HC = require "libraries..HC"
--Classes
require "classes..player"
require "classes..ball"
--Debug
debug = true

function love.load()
    --Init player
    player = Player(10, (love.graphics:getHeight() / 2))

    --Init ball
    ball = Ball()

    --create world bounds
    worldBounds = {
        top    = HC.rectangle(0,1,800,1),
        bottom = HC.rectangle(0,599, 800, 1),
        right  = HC.rectangle(0,1, 1, 600),
        left   = HC.rectangle(799, 0, 1, 600)
    }
end

function love.update(dt)
    player.update(player, dt)
    ball.update(ball, dt)

    for shape, delta in pairs(HC.collisions(player.collider)) do
        if player.collider:collidesWith(worldBounds.top) then
            player.y = 3           
        elseif player.collider:collidesWith(worldBounds.bottom) then
            player.y = love.graphics:getHeight() - player.img:getHeight() - 3
        end
    end

    for shape, delta in pairs(HC.collisions(ball.collider)) do       
        if ball.collider:collidesWith(worldBounds.left) then
            ball.x = ball.originX
            ball.y = ball.originY
        elseif ball.collider:collidesWith(worldBounds.right) then
            ball.x = ball.originX
            ball.y = ball.originY
        end
    end

    ball.handleCollisions(ball, player)
end

function love.draw()
    --Draw player
    player.draw(player)
    ball.draw(ball)

    --Draw world bounds
    worldBounds.top:draw('line')
    worldBounds.bottom:draw('line')
    worldBounds.right:draw('line')
    worldBounds.left:draw('line')

    --Draw FPS Counter
    love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( )), 10, 10)
end