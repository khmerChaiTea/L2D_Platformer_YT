local sti = require("libraries.sti")

local map = {}

function map:load()
    self.currentLevel = 1
    world = love.physics.newWorld(0, 2000)
    world:setCallbacks(beginContact, endContact)
    self:init()
end

function map:init()
    self.level = sti("maps/" .. self.currentLevel .. ".lua", { "box2d" })
    self.level:box2d_init(world)

    self.solidLayer = self.level.layers.solid
    self.groundLayer = self.level.layers.ground
    self.entityLayer = self.level.layers.entity

    if self.solidLayer then
        self.solidLayer.visible = false
        for _, obj in ipairs(self.solidLayer.objects) do
            if obj.physics and obj.physics.fixture then
                obj.physics.fixture:setUserData({ type = "wall" })
            end
        end
    end

    if self.entityLayer then
        self.entityLayer.visible = false
    end

    self.mapWidth = (self.groundLayer and self.groundLayer.width or 0) * 16
    self:spawnEntities()
end

function map:spawnEntities()
    if not self.entityLayer then return end
    for _, obj in ipairs(self.entityLayer.objects) do
        local cx = obj.x + (obj.width or 0) / 2
        local cy = obj.y + (obj.height or 0) / 2

        if obj.type == "spike" then
            spike.new(cx, cy)
        elseif obj.type == "stone" then
            stone.new(cx, cy)
        elseif obj.type == "enemy" then
            enemy.new(cx, cy)
        elseif obj.type == "coin" then
            coin.new(obj.x, obj.y)
        end
    end
end

function map:next()
    self:clean()
    self.currentLevel = self.currentLevel + 1
    self:init()
    if player.resetPosition then
        player:resetPosition()
    end
end

function map:clean()
    if self.level then
        self.level:box2d_removeLayer("solid")
    end
    coin.removeAll()
    enemy.removeAll()
    stone.removeAll()
    spike.removeAll()
end

function map:update(dt)
    if self.level and self.level.update then
        self.level:update(dt)
    end
    if player.x > self.mapWidth - player.width / 2 then
        self:next()
    end
end

function map:draw()
    local ground = self.level.layers.ground
    local grass  = self.level.layers.grass

    if ground then self.level:drawLayer(ground) end
    if grass  then self.level:drawLayer(grass)  end
end

return map