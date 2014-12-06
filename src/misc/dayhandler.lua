
dayHandler = {}

local lock = false
local samples = nil

local research = {}

research[1] = {
        Research("solar", "Solar array", "Extend solar array"),
        Research("gelonium", "Res. Gelonium", "+1 Mineral from Gelonium sources"),  
        Research("glazium", "Res. Glazium", "+1 Mineral from Gelonium sources"),
    }

local function defineRessources()
    local effects = {}
    effects[1] = Effect("Gelonium", 10, 1, function(effect) effect.mineral = 2 research_gelonium = true end)
    effects[2] = Effect("Glazium", 5, 2, function(effect) effect.mineral = 3  research_glazium = true  end)
    
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

function dayHandler.getResearch()
    return research
end
