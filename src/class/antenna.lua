local antenna = love.graphics.newImage("res/antenna.png")

Antenna = Class {
    init = function(self, x, y)
        self.x = x
        self.y = y
        self.selected = false
        self.built = false
        self.work = 3
    end
}


function Antenna:update(dt)
    
end

function Antenna:finishWork()
    dayHandler.free()
    audio_noise:play()
    antenna_built = true
    self.built = true
    return true
end

-- on click event
function Antenna:action(button)
    if buildmode and not self.built then 
        probe:register(self)
        stat.energy = stat.energy - 1
        self.active = true
    end
end

function Antenna:draw(scale)
    
    local img = antenna
    if not self.built then img = tobuild end
    
    love.graphics.setColor(color.white)
    if self.selected then love.graphics.setColor(color.selected) end
    love.graphics.draw(img, self.x * scale.tw, self.y * scale.th, 0, scale.x * 0.4, scale.y * 0.4, img:getWidth() / 4, img:getHeight() / 1.5)
end
