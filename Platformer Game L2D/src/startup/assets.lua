function loadAssets()
    -- General game assets
    sprites = {}
    sprites.background = love.graphics.newImage("sprites/background.png")

    -- Player animation assets
    player.animation = {timer = 0, rate = 0.1}

    player.animation.run = {total = 6, current = 1, img = {}}
    for i = 1, player.animation.run.total do
        player.animation.run.img[i] = love.graphics.newImage("sprites/player/run/" .. i .. ".png")
    end

    player.animation.idle = {total = 4, current = 1, img = {}}
    for i = 1, player.animation.idle.total do
        player.animation.idle.img[i] = love.graphics.newImage("sprites/player/idle/" .. i .. ".png")
    end

    player.animation.air = {total = 4, current = 1, img = {}}
    for i = 1, player.animation.air.total do
        player.animation.air.img[i] = love.graphics.newImage("sprites/player/air/" .. i .. ".png")
    end

    -- Initial animation frame and dimensions
    player.animation.draw = player.animation.idle.img[1]
    player.animation.width = player.animation.draw:getWidth()
    player.animation.height = player.animation.draw:getHeight()

    -- Coin image
    sprites.coin = love.graphics.newImage("sprites/coin.png")
    sprites.coins = love.graphics.newImage("sprites/coin.png")
    sprites.font = love.graphics.newFont("fonts/bit.ttf", 36)

    -- Spike image
    sprites.spike = love.graphics.newImage("sprites/spikes.png")

    -- Heart image
    sprites.heart = love.graphics.newImage("sprites/heart.png")

    -- Stone image
    sprites.stone = love.graphics.newImage("sprites/stone.png")

     -- Enemy Animations
     sprites.enemy = {}
     sprites.enemy.walk = {}
     sprites.enemy.run = {}
 
     -- First load the images into the enemy sprite arrays
     for i = 1, 4 do
         sprites.enemy.walk[i] = love.graphics.newImage("sprites/enemy/walk/" .. i .. ".png")
         sprites.enemy.run[i] = love.graphics.newImage("sprites/enemy/run/" .. i .. ".png")
     end
 
     -- Assign the walk and run animations to the enemy object
     enemy.walkAnim = sprites.enemy.walk
     enemy.runAnim = sprites.enemy.run
end