local mineral_orange = love.graphics.newImage("res/mineral_orange.png")
local mineral_blue = love.graphics.newImage("res/mineral_blue.png")
local arrow = love.graphics.newImage("res/arrow.png")

Mineral = Class {
    init = function(self, x, y, typ)
        self.x = x
        self.y = y
        self.typ = typ
        self.selected = false -- hover highlight
        self.active = false -- current probe target
        self.work = 5
    end
}

function Mineral:update(dt)
    
end

function Mineral:finishWork()
    probe:give(self.typ)
    return true
end

-- on click event
function Mineral:action()
    probe:register(self)
    self.active = true
end

function Mineral:draw(scale)
    local img = mineral_blue
    if self.typ == "mineral_orange" then img = mineral_orange end
    love.graphics.draw(img, self.x * scale.tw, self.y * scale.th, 0, scale.x * 0.4, scale.y * 0.4, img:getWidth() / 4, img:getHeight() / 4 )
    if self.active then
        love.graphics.draw(arrow, self.x * scale.tw, self.y * scale.th, 0, scale.x * 0.4, scale.y * 0.4, arrow:getWidth() / 4, arrow:getHeight() / 1.2 )
    end
end
