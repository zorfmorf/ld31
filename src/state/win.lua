local lander = love.graphics.newImage("res/lander.png")
local solar = love.graphics.newImage("res/lander_solar.png")
local auspex = love.graphics.newImage("res/lander_auspex.png")


state_win = Gamestate.new()

local reason = nil
local solartext = "You won!\n\nEnding: Space Colony"
local worktext = "You won!\n\nEnding: Wörk, wörk!"

local dtv = 0

function state_win:enter()
    
    reason = solartext
    -- todo: hook up wörk ending
    if false then
        reason = worktext
    end
    
    dtv = 0
end

function state_win:update(dt)
    dtv = dtv + dt
end

function state_win:draw()
    
    local screen = {
        w = love.graphics.getWidth(),
        h = love.graphics.getHeight()
    }
    
    state_space:draw()
    love.graphics.setColor(0, 0, 0, math.min(255, 0 + dtv * 50))
    love.graphics.rectangle("fill", 0, 0, screen.w, screen.h)
    if dtv > 4 then
        
        love.graphics.setColor(255, 255, 255, 255)
        if reason == solartext then
            love.graphics.draw(lander, screen.w / 2, screen.h / 6, 0, 1, 1, lander:getWidth())
            love.graphics.draw(solar, screen.w / 2, screen.h / 6, 0, 1, 1, lander:getWidth())
            love.graphics.draw(auspex, screen.w / 2, screen.h / 6, 0, 1, 1, lander:getWidth())
        end
        
        love.graphics.setColor(color.red)
        love.graphics.setFont(titlefont)
        local wwid, wrap = titlefont:getWrap(reason, screen.w / 2)
        
        love.graphics.printf(reason, screen.w / 2, screen.h / 3, screen.w/2, "center", 0, 1, 1, wwid / 2)
    end
end

function state_win:keypressed(key, isrepeat)
    if key == "escape" then
        love.event.push("quit")
    end
end
