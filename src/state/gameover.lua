
state_gameover = Gamestate.new()

local dtv = 0
local reason = nil

function state_gameover:enter()

    reason = "Game Over\n\nYou are depressed...\n\n(Pay attention to the mood bar under the left monitor and play the space game to improve mood)"
    
    if player.stats.work <= 0 then
        reason = "Game Over\n\nYour boss has lost his patience...\n\n(Open the work application and type something to keep him happy)"
    end
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

function state_gameover:keypressed(key, isrepeat)
    if key == "escape" then
        love.event.push("quit")
    end
end
