local camera = {
    x = 0,
    y = 0,
    scale = 2
}

function camera:apply()
    love.graphics.push()
    love.graphics.scale(self.scale, self.scale)
    love.graphics.translate(-self.x, -self.y)
end

function camera:clear()
    love.graphics.pop()
end

function camera:setPosition(x, y)
    self.x = x - love.graphics.getWidth() / 2 /self.scale
    self.y = y
    local RS = self.x + love.graphics.getWidth() / 2

    if self.x < 0 then
        self.x = 0
    elseif RS > map.mapWidth  then
        self.x = map.mapWidth - love.graphics.getWidth() /2
    end
end

return camera