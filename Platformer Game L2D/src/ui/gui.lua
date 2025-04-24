local gui = {}

function gui:load()
    self.coins = {}
    self.coins.img = sprites.coins
    self.coins.width = self.coins.img:getWidth()
    self.coins.height = self.coins.img:getHeight()
    self.coins.scale = 3
    self.coins.x = love.graphics.getWidth() - 200
    self.coins.y = 50

    self.hearts = {}
    self.hearts.img = sprites.heart
    self.hearts.width = self.coins.img:getWidth()
    self.hearts.height = self.coins.img:getHeight()
    self.hearts.x = 0
    self.hearts.y = 30
    self.hearts.scale = 3
    self.hearts.spacing = self.hearts.width * self.hearts.scale + 30

    self.font = sprites.font
end

function gui:update(dt)
    
end

function gui:draw()
    self:displayCoins()
    self:displayCoinsText()
    self:displayHearts()
end

function gui:displayHearts()
    for i = 1, player.health.current do
        local x = self.hearts.x + self.hearts.spacing * i
        love.graphics.setColor(0, 0, 0, 0.5)
        love.graphics.draw(self.hearts.img, x + 2, self.hearts.y + 2, 0, self.hearts.scale, self.hearts.scale)
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.draw(self.hearts.img, x, self.hearts.y, 0, self.hearts.scale, self.hearts.scale)
    end
end

function gui:displayCoins()
    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.draw(self.coins.img, self.coins.x + 2, self.coins.y + 2, 0, self.coins.scale, self.coins.scale)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(self.coins.img, self.coins.x, self.coins.y, 0, self.coins.scale, self.coins.scale)
end

function gui:displayCoinsText()
    love.graphics.setFont(self.font)
    local x = self.coins.x + self.coins.width * self.coins.scale
    local y = self.coins.y + self.coins.height / 2 * self.coins.scale - self.font:getHeight() / 2
    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.print(" : "..player.coins, x + 2, y + 2)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print(" : "..player.coins, x, y)
end

return gui