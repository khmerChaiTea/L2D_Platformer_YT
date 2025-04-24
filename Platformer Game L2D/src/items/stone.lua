local stone = {}
stone.__index = stone

local activeStones = {}

function stone.removeAll()
    for i, v in ipairs(activeStones) do
        v.physics.body:destroy()
    end

    activeStones = {}
end

function stone.new(x, y)
    local instance = setmetatable({}, stone)
    instance.x = x
    instance.y = y
    instance.r = 0
    instance.img = sprites.stone
    instance.width = instance.img:getWidth()
    instance.height = instance.img:getHeight()

    instance.physics = {}
    instance.physics.body = love.physics.newBody(world, instance.x, instance.y, "dynamic")
    instance.physics.shape = love.physics.newRectangleShape(instance.width, instance.height)
    instance.physics.fixture = love.physics.newFixture(instance.physics.body, instance.physics.shape)
    instance.physics.body:setMass(25)
    table.insert(activeStones, instance)
end

function stone:update(dt)
    self:syncPhysics()
end

function stone:syncPhysics()
    self.x, self.y = self.physics.body:getPosition()
    self.r = self.physics.body:getAngle()
end

function stone:draw()
    love.graphics.draw(self.img, self.x, self.y, self.r, self.scaleX, 1, self.width / 2, self.height / 2)
end

function stone.updateAll(dt)
    for i, instance in ipairs(activeStones) do
        instance:update(dt)
    end
end

function  stone.drawAll()
    for i, instance in ipairs(activeStones) do
        instance:draw()
    end
end

return stone