local solarpanel = love.graphics.newImage("res/solarpanel.png")

Solarpanel = Class {
    init = function(self, x, y)
        self.x = x
        self.y = y
        self.selected = false
        self.built = false
        self.work = 3
    end
}


function Solarpanel:update(dt)
    
end

function Solarpanel:finishWork()
    dayHandler.free()
    self.built = true
    stat.energypd = stat.energypd + 1
    return true
end

-- on click event
function Solarpanel:action(button)
    if buildmode and dayHandler.lock() then 
        probe:register(self)
        stat.energy = stat.energy - 1
        self.active = true
    end
end


function Solarpanel:draw(scale)
    
    local img = solarpanel
    if not self.built then img = tobuild end
    
    love.graphics.setColor(color.white)
    if self.selected then love.graphics.setColor(color.selected) end
    love.graphics.draw(img, self.x * scale.tw, self.y * scale.th, 0, scale.x * 0.4, scale.y * 0.4, img:getWidth() / 4, img:getHeight() / 4)
end
