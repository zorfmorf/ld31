
state_intro = Gamestate.new()

local delta = 0

function state_intro:enter()
    state_ingame:enter()
end

function state_intro:update(dt)
    state_ingame:update(dt)
    delta = delta + dt
    
    -- switch to spaceship view after 30 seconds
    if delta > 10 then
        Gamestate.switch(state_intro)
    end
    
    -- try to find momentary lags
    local fps = love.timer.getFPS()
    if DEBUG and delta > 3 and fps < 20 then
        print(love.timer.getTime(), fps)
    end
end

function state_intro:draw()
    local canvas = love.graphics.newCanvas(love.graphics.getWidth(), love.graphics.getHeight())
    state_ingame:draw(canvas)
    
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.draw(canvas, 0, 0)
    
    love.graphics.setColor(0, 0, 0, math.max(0, 255 - delta * 10))
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
end

function state_intro:mousepressed( x, y, button )
    if delta > 5 then
        state_ingame:mousepressed( x, y, button )
    end
end
