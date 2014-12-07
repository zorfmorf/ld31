
-- load libraries
Gamestate = require "lib.hump.gamestate"
Class = require "lib.hump.class"
Vector = require "lib.vector"

-- load states
require "state.ingame"
require "state.gameover"
require "state.intro"
require "state.space"

-- load classes
require "class.lander"
require "class.probe"
require "class.mineral"
require "class.task"
require "class.effect"
require "class.solarpanel"
require "class.asteroid"

require "class.desktop"

-- load misc
require "misc.taskhandler"
require "misc.dayhandler"

function love.load()
    Gamestate.registerEvents()
    Gamestate.switch(state_intro)
    
    font = love.graphics.newFont("font/Orbitron Medium.ttf", 15)
    landerfont = love.graphics.newFont("font/Orbitron Medium.ttf", 40)
    titlefont = love.graphics.newFont("font/Orbitron Medium.ttf", 50)
    signfont = love.graphics.newFont(30)
    signfont2 = love.graphics.newFont(15)
    love.graphics.setFont(font)
    DEBUG = true
    
    icon_mineral = love.graphics.newImage("res/icon_mineral.png")
    icon_science = love.graphics.newImage("res/icon_science.png")
    icon_energy = love.graphics.newImage("res/icon_energy.png")
    icon_mousel = love.graphics.newImage("res/icon_mousel.png")
    icon_mouser = love.graphics.newImage("res/icon_mouser.png")
    
    tobuild = love.graphics.newImage("res/tobuild.png")
    
    math.randomseed(os.time())
    
end


function love.update(dt)
    
end


function love.draw()
    
end
