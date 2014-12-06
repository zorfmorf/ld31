
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
require "class.task"

-- load misc
require "misc.taskhandler"

function love.load()
    Gamestate.registerEvents()
    Gamestate.switch(state_ingame)
    
    font = love.graphics.newFont("font/Orbitron Medium.ttf", 15)
    landerfont = love.graphics.newFont("font/Orbitron Medium.ttf", 40)
    love.graphics.setFont(font)
    DEBUG = true
end


function love.update(dt)
    
end


function love.draw()
    love.graphics.print("")
end
