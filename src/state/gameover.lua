
state_gameover = Gamestate.new()

local dtv = 0
local reason = nil

function state_gameover:enter()
    -- todo find reason for gameover
    -- todo evaluate points or something
    reason = "Your mood bar has reached zero. Play the lander game in the left screen to increase mood."
    
    if player.stats.work <= 0 then
        reason = "Your boss has lost his patience. Open the work application and type something to keep him happy."
    end
    
    reason = reason .. "\n\n\nfin"
end

function state_gameover:update(dt)
    dtv = dtv + dt
end

function state_gameover:draw()
    
    local screen = {
        w = love.graphics.getWidth(),
        h = love.graphics.getHeight()
    }
    
    state_space:draw()
    love.graphics.setColor(0, 0, 0, math.min(255, 0 + dtv * 50))
    love.graphics.rectangle("fill", 0, 0, screen.w, screen.h)
    if dtv > 4 then
        love.graphics.setColor(color.red)
        love.graphics.setFont(titlefont)
        local wwid, wrap = titlefont:getWrap(reason, screen.w / 2)
        
        love.graphics.printf(reason, screen.w / 2, screen.h / 4, screen.w/2, "center", 0, 1, 1, wwid / 2)
    end
end
