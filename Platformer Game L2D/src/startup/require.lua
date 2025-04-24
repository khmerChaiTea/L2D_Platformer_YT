function requireAll()
    require("src/startup/collisionClasses")
    createCollisionClasses()
    
    require("src.startup.assets")       -- Make sure this is FIRST if others use `sprites`
	
    player = require("src.systems.player")
    require("src.systems.update")
    require("src.systems.draw")

    map = require("src.world.map")

    gui = require("src.ui.gui")

    coin = require("src.items.coin")
    spike = require("src.items.spike")
    stone = require("src.items.stone")

    camera = require("src.utilities.camera")

    enemy = require("src.systems.enemy")
end