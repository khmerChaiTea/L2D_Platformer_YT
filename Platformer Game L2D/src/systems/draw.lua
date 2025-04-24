function drawBeforeCamera()
    -- UI or background
end

function drawCamera()
    love.graphics.draw(sprites.background, 0, 0)

    camera:apply()

    if map and map.draw then
        map:draw()
    end

    player:draw()
    coin.drawAll()
    spike.drawAll()
    stone.drawAll()
    enemy.drawAll()
    camera:clear()
end

function drawAfterCamera()
    gui:draw()
end