
dayHandler = {}

local lock = false
local samples = nil

local function defineRessources()
    local effects = {}
    effects[1] = Effect(10, 1, function(effect) effect.mineral = 2 end)
    effects[2] = Effect(5, 2, function(effect) effect.mineral = 3 end)
    effects[3] = Effect(2, 3, function(effect) effect.mineral = 4 end)
    
    samples = {}
    samples.mineral_orange = table.remove(effects, math.random(1, #effects))
    samples.mineral_blue = table.remove(effects, math.random(1, #effects))
    samples.mineral_brown = table.remove(effects, math.random(1, #effects))
    samples.asteroid = Effect(6, 1, function(effect) effect.mineral = 4 end)
end

function dayHandler.init()
    lock = false
    defineRessources()
end

function dayHandler.getEffect(name)
    return samples[name]
end

function dayHandler.lock()
    if not lock then
        lock = true
        player.increaseMood()
        audio_click:play()
        return true
    end
    return false
end

function dayHandler.free()
    lock = false
    dayHandler.finish()
end

function dayHandler.finish()
    stat.day = stat.day + 1
    stat.energy = stat.energy + stat.energypd
    if stat.energy < 0 then
        Gamestate.switch(state_gameover)
    end
    
    -- handle asteroids
    if math.random(100) + math.min(stat.day, 70) > 80 then
        local x = math.random(0,30)
        local y = math.random(6,15)
        if not (x == lander.x and y == lander.y) then
            --addEntity(Asteroid(x, y))
        end
    end
end
