
player = {}

-- if either stat reaches zero, its game over
player.stats = {
    mood = 5,
    work = 5
}

local delta = 0
local delta2 = 0

function player.init()
    
end

function player.update(dt)
    delta = delta + dt
    delta2 = delta2 + dt
    if delta > 20 then
        delta = 0
        player.stats.mood = math.max(0, player.stats.mood - 1)
        if player.stats.mood <= 0 then
            Gamestate.switch(state_gameover)
        end
    end
    if delta2 > 5 then
        delta2 = 0
        player.stats.work = math.max(0, player.stats.work - 1)
        if player.stats.work <= 0 then
            Gamestate.switch(state_gameover)
        end
    end
end

function player.increaseMood()
    player.stats.mood = math.min(5, math.max(2, player.stats.mood + 1))
end

function player.increaseWork()
    player.stats.work = math.min(5, player.stats.work + 1)
end
