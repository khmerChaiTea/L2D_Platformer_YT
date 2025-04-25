local enemy = {}
enemy.__index = enemy

local activeEnemies = {}

function enemy.removeAll()
    for _, e in ipairs(activeEnemies) do
        e.physics.body:destroy()
    end
    activeEnemies = {}
end

function enemy.new(x, y)
    local e = setmetatable({}, enemy)
    e.x, e.y = x, y
    e.offsetY = -8
    e.width  = sprites.enemy.walk[1]:getWidth()
    e.height = sprites.enemy.walk[1]:getHeight()

    e.speed = 100
    e.direction = 1
    e.state = "walk"
    e.damage = 1

    e.animation = {
        timer = 0, rate = 0.1,
        walk = { total = 4, current = 1, img = enemy.walkAnim },
        draw = enemy.walkAnim[1],
    }

    -- Physics
    e.physics = {}
    e.physics.body = love.physics.newBody(world, e.x, e.y, "dynamic")
    e.physics.body:setFixedRotation(true)
    e.physics.shape = love.physics.newRectangleShape(e.width * 0.4, e.height * 0.75)
    e.physics.fixture = love.physics.newFixture(e.physics.body, e.physics.shape)
    e.physics.body:setMass(25)
    e.physics.fixture:setUserData({ type = "enemy", ref = e })

    table.insert(activeEnemies, e)
    return e
end

function enemy:update(dt)
    self:animate(dt)
    self:syncPhysics()
end

function enemy:syncPhysics()
    self.x, self.y = self.physics.body:getPosition()
    local _, vy = self.physics.body:getLinearVelocity()
    self.physics.body:setLinearVelocity(self.direction * self.speed, vy)
end

function enemy:flipDirection()
    self.direction = -self.direction
end

function enemy:animate(dt)
    self.animation.timer = self.animation.timer + dt
    if self.animation.timer > self.animation.rate then
        self.animation.timer = 0
        local a = self.animation.walk
        a.current = (a.current % a.total) + 1
        self.animation.draw = a.img[a.current]
    end
end

function enemy:draw()
    local sx = (self.direction < 0) and -1 or 1
    love.graphics.draw(
        self.animation.draw,
        self.x, self.y + self.offsetY, 0,
        sx, 1,
        self.width / 2, self.height / 2
    )
end

function enemy.updateAll(dt)
    for _, e in ipairs(activeEnemies) do
        e:update(dt)
    end
end

function enemy.drawAll()
    for _, e in ipairs(activeEnemies) do
        e:draw()
    end
end

-- CALLBACK: Collision detection
function enemy.beginContact(a, b, collision)
    if not (a and b) then return end
    local aData = a:getUserData() or {}
    local bData = b:getUserData() or {}

    local function isEnemy(d) return d.type == "enemy" end
    local function isPlayer(d) return d.type == "player" end
    local function isWall(d)   return d.type == "wall"   end

    if isEnemy(aData) then
        local e = aData.ref
        if isPlayer(bData) then
            player:takeDamage(e.damage)
            -- Push player to the side
            local px, _ = player:getPosition()
            local ex, _ = e.physics.body:getPosition()
            local push = (px < ex) and -100 or 100
            player:applyImpulse(push, -200)
            e:flipDirection()
        elseif isWall(bData) then
            e:flipDirection()
        end
    elseif isEnemy(bData) then
        local e = bData.ref
        if isPlayer(aData) then
            player:takeDamage(e.damage)
            local px, _ = player:getPosition()
            local ex, _ = e.physics.body:getPosition()
            local push = (px < ex) and -100 or 100
            player:applyImpulse(push, -200)
            e:flipDirection()
        elseif isWall(aData) then
            e:flipDirection()
        end
    end
end

return enemy