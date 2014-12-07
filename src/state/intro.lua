
state_intro = Gamestate.new()

local delta = 0

function state_intro:enter()
    state_ingame:enter()
end

function state_intro:update(dt)
    state_ingame:update(dt)
    delta = delta + dt
    
    -- switch to spaceship view after 30 seconds
    if delta > 30 then
        Gamestate.switch(state_space)
    end
    
end

function state_intro:draw()
    
    local canvas = state_ingame:draw(delta)
    
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.draw(canvas, 0, 0)
    
    love.graphics.setColor(0, 0, 0, math.max(0, 255 - delta * 10))
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
end

function state_intro:mousepressed( x, y, button )
    if delta > 2 then
        state_ingame:mousepressed( x, y, button )
    end
end
