local img = love.graphics.newImage("res/probe.png")

local feel_happy = love.graphics.newImage("res/feel_happy.png")
local feel_mhm = love.graphics.newImage("res/feel_mhm.png")
local feel_sad = love.graphics.newImage("res/feel_sad.png")
local feel_work = love.graphics.newImage("res/feel_work.png")
local feel_oh = love.graphics.newImage("res/feel_oh.png")

Probe = Class {
    init = function(self, x, y)
        self.x = x
        self.y = y
        self.selected = false
        self.feeling = 0
        self.feelingdt = 0
        self.target = nil
        self.speed = 5
        self.move = nil
    end
}

function Probe:calcMove()
    self.move = Vector:c(self.target.x - self.x, self.target.y - self.y)
    if self.move:len() > 1 then self.move = self.move:norm() end
end

function Probe:update(dt)
    if self.feelingdt > 0 then 
        self.feelingdt = self.feelingdt - dt 
    else
        self.feeling = nil
    end
    
    -- drive to target if applicable
    if self.target then
        if math.abs(self.x - self.target.x) < 0.2 and math.abs(self.y - self.target.y) < 0.2 then
            self:register(nil)
        else
            self:calcMove()
            self.x = self.x + self.move.x * dt * self.speed
            self.y = self.y + self.move.y * dt * self.speed
        end
    end
end

-- on click event
function Probe:action()
    self.feelingdt = 1
    self.feeling = feel_happy
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
    if self.feeling then
        love.graphics.draw(self.feeling, self.x * scale.tw, self.y * scale.th, 0, scale.x * 0.4, scale.y * 0.4, 0, self.feeling:getHeight())
    end
end
