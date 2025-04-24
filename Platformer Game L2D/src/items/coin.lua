local coin = {}
coin.__index = coin

local activeCoins = {}

function coin.new(x, y)
    local instance = setmetatable({}, coin)
    instance.x = x
    instance.y = y
    instance.img = sprites.coin
    instance.width = instance.img:getWidth()
    instance.height = instance.img:getHeight()
    instance.scaleX = 1
    instance.randomTimeOffset = math.random(0, 100)
    instance.toBeRemoved = false

    instance.physics = {}
    instance.physics.body = love.physics.newBody(world, instance.x, instance.y, "static")
    instance.physics.shape = love.physics.newRectangleShape(instance.width, instance.height)
    instance.physics.fixture = love.physics.newFixture(instance.physics.body, instance.physics.shape)
    instance.physics.fixture:setSensor(true)
    table.insert(activeCoins, instance)
end

function coin:remove()
    for i, instance in ipairs(activeCoins) do
        if instance == self then
            player:incrementCoin()
            print(player.coins)
            self.physics.body:destroy()
            table.remove(activeCoins, i)
        end
    end
end

function coin.removeAll()
    for i, v in ipairs(activeCoins) do
        v.physics.body:destroy()
    end

    activeCoins = {}
end

function coin:update(dt)
    self:spin(dt)
    self:checkRemove()
end

function coin:checkRemove()
    if self.toBeRemoved then
        self:remove()
    end
end

function coin:spin(dt)
    self.scaleX = math.sin(love.timer.getTime() * 2 + self.randomTimeOffset)
end

function coin:draw()
    love.graphics.draw(self.img, self.x, self.y, 0, self.scaleX, 1, self.width / 2, self.height / 2)
end

function coin.updateAll(dt)
    for i, instance in ipairs(activeCoins) do
        instance:update(dt)
    end
end

function  coin.drawAll()
    for i, instance in ipairs(activeCoins) do
        instance:draw()
    end
end

function coin.beginContact(a, b, collision)
    for i, instance in ipairs(activeCoins) do
        if a == instance.physics.fixture or b == instance.physics.fixture then
            if a == player.physics.fixture or b == player.physics.fixture then
                instance.toBeRemoved = true
                return true
            end
        end
    end
end

return coin