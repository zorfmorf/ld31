
-- load libraries
Gamestate = require "lib.hump.gamestate"
Class = require "lib.hump.class"
Vector = require "lib.vector"

-- load states
require "state.ingame"

-- load classes
require "class.lander"
require "class.probe"
require "class.mineral"

function love.load()
    Gamestate.registerEvents()
    Gamestate.switch(state_ingame)
end


function love.update(dt)
    
end


function love.draw()
    
end
