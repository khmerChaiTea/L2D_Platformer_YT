local spike = {}
spike.__index = spike

local activeSpikes = {}

function spike.removeAll()
    for i, v in ipairs(activeSpikes) do
        v.physics.body:destroy()
    end

    activeSpikes = {}
end

function spike.new(x, y)
    local instance = setmetatable({}, spike)
    instance.x = x
    instance.y = y
    instance.img = sprites.spike
    instance.width = instance.img:getWidth()
    instance.height = instance.img:getHeight()

    instance.damage = 1

    instance.physics = {}
    instance.physics.body = love.physics.newBody(world, instance.x, instance.y, "static")
    instance.physics.shape = love.physics.newRectangleShape(instance.width, instance.height)
    instance.physics.fixture = love.physics.newFixture(instance.physics.body, instance.physics.shape)
    instance.physics.fixture:setSensor(true)
    table.insert(activeSpikes, instance)
end

function spike:update(dt)

end

function spike:draw()
    love.graphics.draw(self.img, self.x, self.y, 0, self.scaleX, 1, self.width / 2, self.height / 2)
end

function spike.updateAll(dt)
    for i, instance in ipairs(activeSpikes) do
        instance:update(dt)
    end
end

function  spike.drawAll()
    for i, instance in ipairs(activeSpikes) do
        instance:draw()
    end
end

function spike.beginContact(a, b, collision)
    for i, instance in ipairs(activeSpikes) do
        if a == instance.physics.fixture or b == instance.physics.fixture then
            if a == player.physics.fixture or b == player.physics.fixture then
                player:takeDamage(instance.damage)
                return true
            end
        end
    end
end

return spike