
state_gameover = Gamestate.new()

local dtv = 0
local reason = nil

function state_gameover:enter()
    -- todo find reason for gameover
    -- todo evaluate points or something
    reason = "Your energy has run out..."
end

function state_gameover:update(dt)
    dtv = dtv + dt
end

function state_gameover:draw()
    state_ingame:draw()
    love.graphics.setColor(0, 0, 0, math.min(255, 0 + dtv * 50))
    love.graphics.rectangle("fill", 0, 0, screen.w, screen.h)
    if dtv > 4 then
        love.graphics.setColor(color.red)
        love.graphics.setFont(titlefont)
        love.graphics.print("fin", screen.w / 2, screen.h / 2, 0, 1, 1, titlefont:getWidth("fin") / 2, titlefont:getHeight()/2)
        love.graphics.print(reason, screen.w / 2, screen.h / 2, 0, 1, 1, titlefont:getWidth(reason) / 2, titlefont:getHeight() * 3)
    end
end
