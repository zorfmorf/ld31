
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
end