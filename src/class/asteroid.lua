local asteroid = love.graphics.newImage("res/asteroid.png")

Asteroid = Class {
    init = function(self, x, y)
        self.x = x
        self.y = y
        self.selected = false
        self.work = 3
        self.destroys = true
        self.typ = "asteroid"
    end
}


function Asteroid:update(dt)
    
end

function Asteroid:finishWork()
    dayHandler.free()
    probe:give(self.typ)
    return true
end

-- on click event
function Asteroid:action(button)
    if dayHandler.lock() then 
        probe:register(self)
        stat.energy = stat.energy - 1
        self.active = true
    end
end


function Asteroid:draw(scale)
    
    local img = asteroid
    
    love.graphics.setColor(color.white)
    if self.selected then love.graphics.setColor(color.selected) end
    love.graphics.draw(img, self.x * scale.tw, self.y * scale.th, 0, scale.x * 0.4, scale.y * 0.4, img:getWidth() / 4, img:getHeight() / 4)
end
