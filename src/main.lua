
-- load libraries
Gamestate = require "lib.hump.gamestate"
Class = require "lib.hump.class"
Vector = require "lib.vector"

-- load states
require "state.ingame"
require "state.gameover"
require "state.intro"
require "state.space"
require "state.win"

-- load classes
require "class.lander"
require "class.probe"
require "class.mineral"
require "class.task"
require "class.effect"
require "class.solarpanel"
require "class.asteroid"
require "class.antenna"

require "class.desktopitem"
require "class.desktop"

-- load misc
require "misc.taskhandler"
require "misc.dayhandler"
require "misc.player"

function love.load()
    math.randomseed(os.time())
    
    Gamestate.registerEvents()
    Gamestate.switch(state_intro)
    
    font = love.graphics.newFont("font/Orbitron Medium.ttf", 15)
    landerfont = love.graphics.newFont("font/Orbitron Medium.ttf", 60)
    titlefont = love.graphics.newFont("font/LeagueGothic-Regular.otf", 40)
    workfont = love.graphics.newFont("font/LeagueGothic-Regular.otf", 6)
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
    player.init()
    
    love.audio.setVolume( 0.5 )
    audio_message = love.audio.newSource("audio/message.ogg")
    audio_noise = love.audio.newSource("audio/noise.ogg")
    audio_sonar = love.audio.newSource("audio/sonar.ogg")
    audio_click = love.audio.newSource("audio/click.ogg")
    audio_music = love.audio.newSource("audio/music.ogg")
    audio_music:setLooping(true)
    audio_processed = love.audio.newSource("audio/processed.ogg")
end


function love.update(dt)
    
end


function love.draw()
    
end
