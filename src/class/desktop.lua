local message = love.graphics.newImage("res/screen2_message.png")
local work = love.graphics.newImage("res/screen2_work.png")
local browser = love.graphics.newImage("res/screen2_browser.png")
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
        table.insert(self.items, Workbox(55, 45, work))
        table.insert(self.items, Desktopitem(5, 5, browser))
        table.insert(self.items, Chatbox(170, 200, message))
    end
}

-- returns the mouse position on the second screen
function Desktop:getMousePosition()
    local mx,my = love.mouse.getPosition()
    my = (my / self.screen.h) * (self.monitor.h - 8)
    if mx <= self.screen.w / 2 then return 0, my end
    mx = ((mx - self.screen.w / 2) / (self.screen.w / 2)) * self.monitor.w
    return mx, my
end


function Desktop:update(dt)
    self.dt = self.dt + dt
    
    
    for i=#self.items,1,-1 do
        local item = self.items[i]
        
        local result = item:update(dt)
        if result and i < #self.items then
            table.remove(self.items, i)
            table.insert(self.items, item)
            return
        end
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


function Desktop:mousepressed( x, y, button )
    if button == "l" then
        --audio_click:play()
        for i=#self.items,1,-1 do
            local item = self.items[i]
            
            local mx, my = self:getMousePosition()
            
            if mx >= item.x and mx < item.x + item.image:getWidth() and
               my >= item.y and my < item.y + item.image:getHeight() then
                
                table.remove(self.items, i)
                table.insert(self.items, item)
                audio_click:play()
                return
            end
        end
    end
end

function Desktop:keypressed(key, isrepeat)
    if self.items and self.items[#self.items].input then
        self.items[#self.items]:addInput(key, isrepeat)
    end
end
