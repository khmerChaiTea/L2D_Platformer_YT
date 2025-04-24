function gameStart()
    love.graphics.setBackgroundColor(25/255, 25/255, 25/255)
    love.graphics.setDefaultFilter("nearest", "nearest")

    require("src.startup.require")
    requireAll()

    loadAssets()

    map:load()            -- This should create the `world` object

    gui:load()

    player:load()         -- Now world and sprites are ready
end