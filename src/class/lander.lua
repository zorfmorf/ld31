
local img0 = love.graphics.newImage("res/lander0.png")
local img1 = love.graphics.newImage("res/lander1.png")

Lander = Class {
    init = function(self, x, y)
        self.x = x
        self.y = y
        self.selected = false
        self.lander = true
    end
}

function Lander:update(dt)
    
end

-- on click event
function Lander:action()
    probe:register(self)
    self.active = true
end

function Lander:draw(scale)
    local img = img0
    love.graphics.draw(img, self.x * scale.tw, self.y * scale.th, 0, scale.x * 0.4, scale.y * 0.4, (img:getWidth() / 2.5), (img:getHeight() / 1.5))
end
