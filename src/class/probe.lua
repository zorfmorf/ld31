local img = love.graphics.newImage("res/probe.png")
local sample = love.graphics.newImage("res/probe_sample.png")

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
        self.sample = nil
    end
}

function Probe:give(sample)
    self.sample = sample
end

function Probe:calcMove()
    self.move = Vector:c(self.target.x - self.x, (self.target.y + 0.5) - self.y)
    self.move = self.move:norm()
end

function Probe:update(dt)
    if self.feelingdt > 0 then 
        self.feelingdt = self.feelingdt - dt 
    else
        self.feeling = nil
    end
    
    -- to delete target: self:register(nil)
    if self.work then
        self.work = self.work - dt
        if self.work <= 0 then
            local result = self.target:finishWork()
            if result then
                self.feeling = feel_happy
            else
                self.feeling = feel_mhm
            end
            self.feelingdt = 1
            self:register(nil)
        end
    else
    
        -- drive to target if applicable or work on target
        if self.target then
            if math.abs(self.x - self.target.x) < 0.2 and math.abs(self.y - (self.target.y + 0.5)) < 0.2 then
                self.work = self.target.work
                self.feelingdt = self.work
                self.feeling = feel_work
            else
                self:calcMove()
                self.x = self.x + self.move.x * dt * self.speed
                self.y = self.y + self.move.y * dt * self.speed
            end
        end
    end
end

-- on click event
function Probe:action(button)
    if not self.feeling then
        self.feelingdt = 1
        self.feeling = feel_happy
    end
end

function Probe:register(target)
    -- first unregister old target
    if self.target then self.target.active = false end
    self.move = nil
    self.work = nil
    
    -- now add new target
    self.target = target
end

function Probe:draw(scale)
    love.graphics.setColor(color.white)
    if self.selected then love.graphics.setColor(color.selected) end
    love.graphics.draw(img, self.x * scale.tw, self.y * scale.th, 0, scale.x * 0.4, scale.y * 0.4, img:getWidth() / 4, img:getHeight() / 4)
    if self.sample then love.graphics.draw(sample, self.x * scale.tw, self.y * scale.th, 0, scale.x * 0.4, scale.y * 0.4, sample:getWidth() / 4, sample:getHeight() / 4) end
    if self.feeling then
        love.graphics.setColor(color.white)
        love.graphics.draw(self.feeling, self.x * scale.tw, self.y * scale.th, 0, scale.x * 0.4, scale.y * 0.4, 30, self.feeling:getHeight() / 1.3)
    end
end
