local message = love.graphics.newImage("res/screen2_message.png")
local mouse = love.graphics.newImage("res/mouse.png")

Desktop = Class {
    init = function(self, spacer, screen)
        self.dt = 0
        self.monitor = {
            x = spacer * 0.9 + 31,
            y = 26,
            w = 370,
            h = 364
        }
        self.screen = screen
    end
}


function Desktop:update(dt)
    self.dt = self.dt + dt
end


function Desktop:draw()
    
    --love.graphics.rectangle("fill", self.monitor.x, self.monitor.y, self.monitor.w, self.monitor.h)
    
    -- last: draw mouse pointer if it is on the second screen
    local mx,my = love.mouse.getPosition()
    if mx > self.screen.w / 2 then
        love.graphics.draw(mouse, self.monitor.x - 5 + ((mx - self.screen.w / 2) / (self.screen.w / 2)) * (self.monitor.w - 5), self.monitor.y - 4 + (my / self.screen.h) * (self.monitor.h - 8), 0, 0.5, 0.5)
    end
end
