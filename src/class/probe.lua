local img = love.graphics.newImage("res/probe.png")

local feel = love.graphics.newImage("res/feel1.png")

Probe = Class {
    init = function(self, x, y)
        self.x = x
        self.y = y
        self.selected = false
        self.feeling = 0
        self.feelingdt = 0
        self.target = nil
        self.speed = 10
        self.move = nil
    end
}

function Probe:calcMove()
    if math.abs(self.x - self.target.x) > math.abs(self.y - self.target.y) then
        self.move = Vector:c(self.target.x - self.x, 0)
    else
        self.move = Vector:c(0, self.target.y - self.y)
    end
    self.move = self.move:norm()
end

function Probe:update(dt)
    if self.feelingdt > 0 then self.feelingdt = self.feelingdt - dt end
    
    -- drive to target if applicable
    if self.target then
        if math.abs(self.x - self.target.x) < 0.1 and math.abs(self.y - self.target.y) < 0.1 then
            self:register(nil)
        else
            if not self.move then self:calcMove() end
            
            -- catch overshooting with large dts
            if math.abs(self.x - self.target.x) < math.abs(self.move.x * dt * self.speed) then 
                self.x = self.target.x 
            else
                self.x = self.x + self.move.x * dt * self.speed
            end
            if math.abs(self.y - self.target.y) < math.abs(self.move.y * dt * self.speed) then 
                self.y = self.target.y
            else
                self.y = self.y + self.move.y * dt * self.speed
            end
            
            if not (self.move.x == 0) and math.abs(self.x - self.target.x) < 0.1 then self.move = nil end
            if self.move and not (self.move.y == 0) and math.abs(self.y - self.target.y) < 0.1 then self.move = nil end
        end
    end
end

-- on click event
function Probe:action()
    self.feelingdt = 1
    self.feeling = 1
end

function Probe:register(target)
    -- first unregister old target
    if self.target then self.target.active = false end
    self.move = nil
    
    -- now add new target
    self.target = target
end

function Probe:draw(scale)
    love.graphics.draw(img, self.x * scale.tw, self.y * scale.th, 0, scale.x * 0.4, scale.y * 0.4, img:getWidth() / 4, img:getHeight() / 4)
    if self.feelingdt > 0 then
        love.graphics.draw(feel, self.x * scale.tw, self.y * scale.th, 0, scale.x * 0.4, scale.y * 0.4, 0, feel:getHeight())
    end
end
