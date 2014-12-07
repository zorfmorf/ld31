local message = love.graphics.newImage("res/screen2_message.png")
local mouse = love.graphics.newImage("res/mouse.png")

Desktop = Class {
    init = function(self)
        
    end
}


function Desktop:update(dt)
    
end


function Desktop:draw(spacer, screen)
    love.graphics.draw(message, spacer * 0.9 + 10, 5, 0, 1, 0.98)
    local mx,my = love.mouse.getPosition()
    if mx > screen.w / 2 then
        love.graphics.draw(mouse, spacer * 0.9 + 25 + ((mx - screen.w / 2)  / screen.w * 2) * (message:getWidth() - 45), 5 + (my / screen.h) * message:getHeight(), 0, 0.5, 0.5)
    end
end
