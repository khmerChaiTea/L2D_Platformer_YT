function updateAll(dt)
    world:update(dt)  -- important for physics

    if map and map.update then
        map:update(dt)
    end

    player:update(dt)
    coin.updateAll(dt)
    spike.updateAll(dt)
    stone.updateAll(dt)
    enemy.updateAll(dt)
    gui:update(dt)
    camera:setPosition(player.x, 0)
end