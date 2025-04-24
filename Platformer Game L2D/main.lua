require("src.startup.gameStart")

function love.load()
    gameStart()
end

function love.update(dt)
    updateAll(dt)
end

function love.draw()
    drawBeforeCamera()
    drawCamera()
    drawAfterCamera()
end

function love.keypressed(key)
    player:jump(key)
end