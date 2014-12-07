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
        
        self.items = {}
        table.insert(self.items, Desktopitem(120, 120, message))
        table.insert(self.items, Chatbox(170, 200, message, "Boss: Your assignment is overdue!\nBoss: Please send it immediately!"))
    end
}

-- returns the mouse position on the second screen
local function getMousePosition()
    local mx,my = love.mouse.getPosition()
    my = (my / self.screen.h) * (self.monitor.h - 8)
    if mx <= self.screen.w / 2 then return 0, my end
    mx = ((mx - self.screen.w / 2) / (self.screen.w / 2)) * self.monitor.w
    return mx, my
end


function Desktop:update(dt)
    self.dt = self.dt + dt
    for i,item in ipairs(self.items) do
        
    end
end


function Desktop:draw()
    
    for i,item in ipairs(self.items) do
        if item.visible then item:draw(self.monitor.x + item.x, self.monitor.y + item.y) end
    end
    
    -- last: draw mouse pointer if it is on the second screen
    local mx,my = love.mouse.getPosition()
    if mx > self.screen.w / 2 then
        love.graphics.draw(mouse, self.monitor.x - 5 + ((mx - self.screen.w / 2) / (self.screen.w / 2)) * (self.monitor.w - 5), self.monitor.y - 4 + (my / self.screen.h) * (self.monitor.h - 8), 0, 0.5, 0.5)
    end
end
