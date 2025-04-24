local sti = require("libraries.sti")

local map = {}

function map:load()
    -- Start at level 1
    self.currentLevel = 1

    -- Set up physics world
    world = love.physics.newWorld(0, 2000)        -- Create physics world
    -- Set collision callbacks AFTER world is created
    world:setCallbacks(beginContact, endContact)

    -- Load the first level
    self:init()
end

function map:init()
    -- Load the Tiled map (with box2d plugin)
    self.level = sti("maps/"..self.currentLevel..".lua", { "box2d" })  -- Enable box2d support

    -- Initialize Box2D colliders from the "solid" layer
    self.level:box2d_init(world)                 -- Corrected: use STI's function

    -- Cache layers
    self.solidLayer = self.level.layers.solid
    self.groundLayer = self.level.layers.ground
    self.entityLayer = self.level.layers.entity

    if self.solidLayer then
        self.solidLayer.visible = false
        -- Tag only those objects with the "collidable" property = true
        for _, obj in ipairs(self.solidLayer.objects) do
            if obj.properties and obj.properties.collidable then
                -- STI puts the Box2D fixture here:
                local fx = obj.physics and obj.physics.fixture
                if fx then
                    fx:setUserData({ type = "solid" })
                end
            end
        end
    end

    if self.entityLayer then
        self.entityLayer.visible = false
    end

    -- calculate width & spawn entities as before...
    self.mapWidth = (self.groundLayer and self.groundLayer.width or 0) * 16

    -- Spawn everything from the "entity" layer
    self:spawnEntities()
end

function map:spawnEntities()
    if not self.entityLayer then return end

    for _, obj in ipairs(self.entityLayer.objects) do
        local cx = obj.x + (obj.width  or 0) / 2
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
    -- Clean up old level
    self:clean()

    -- Advance level counter
    self.currentLevel = self.currentLevel + 1

    -- Load the new level
    self:init()

    -- Reset player (if you have that method)
    if player.resetPosition then
        player:resetPosition()
    end
end

function map:clean()
    -- Remove Box2D bodies for the "solid" layer
    if self.level then
        self.level:box2d_removeLayer("solid")
    end

    -- Clear out any spawned entities
    coin.removeAll()
    enemy.removeAll()
    stone.removeAll()
    spike.removeAll()
end

function map:update(dt)
    -- Update the internal STI map (needed for animations, etc.)
    if self.level and self.level.update then
        self.level:update(dt)
    end

    -- If the player reaches the right edge, go to next level
    if player.x > self.mapWidth - player.width / 2 then
        self:next()
    end
end

function map:draw()
    -- Draw ground and grass layers (in the correct order)
    local ground = self.level.layers.ground
    local grass  = self.level.layers.grass

    if ground then self.level:drawLayer(ground) end
    if grass  then self.level:drawLayer(grass)  end
end

return map
