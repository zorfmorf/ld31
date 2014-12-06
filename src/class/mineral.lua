local img1 = love.graphics.newImage("res/mineral1.png")
local img2 = love.graphics.newImage("res/mineral2.png")
local arrow = love.graphics.newImage("res/arrow.png")

Mineral = Class {
    init = function(self, x, y, typ)
        self.x = x
        self.y = y
        self.typ = typ
        self.selected = false -- hover highlight
        self.active = false -- current probe target
    end
}

function Mineral:update(dt)
    
end

-- on click event
function Mineral:action()
    probe:register(self)
    self.active = true
end

function Mineral:draw(scale)
    local img = img1
    if self.typ == 2 then img = img2 end
    love.graphics.draw(img, self.x * scale.tw, self.y * scale.th, 0, scale.x * 0.4, scale.y * 0.4, img:getWidth() / 4, img:getHeight() / 4 )
    if self.active then
        love.graphics.draw(arrow, self.x * scale.tw, self.y * scale.th, 0, scale.x * 0.4, scale.y * 0.4, arrow:getWidth() / 4, arrow:getHeight() / 1.2 )
    end
end
