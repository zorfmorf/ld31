local mineral_orange = love.graphics.newImage("res/mineral_orange.png")
local mineral_blue = love.graphics.newImage("res/mineral_blue.png")
local mineral_brown = love.graphics.newImage("res/mineral_brown.png")
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
    dayHandler.free()
    probe:give(self.typ)
    return true
end

-- on click event
function Mineral:action(button)
    if dayHandler.lock() then 
        probe:register(self)
        stat.energy = stat.energy - 1
        self.active = true
    end
end

function Mineral:draw(scale)
    local img = mineral_blue
    if self.typ == "mineral_orange" then img = mineral_orange end
    if self.typ == "mineral_brown" then img = mineral_brown end
    
    -- if selected draw infobox
    if self.selected then
        love.graphics.setColor(color.white)
        love.graphics.rectangle("fill", self.x * scale.tw - 25, self.y * scale.th - 75, 75, 75)
        love.graphics.setColor(color.black)
        love.graphics.rectangle("line", self.x * scale.tw - 25, self.y * scale.th - 75, 75, 75)
        
        local effect = dayHandler.getEffect(self.typ)
        love.graphics.setFont(signfont)
        love.graphics.print("-1", self.x * scale.tw + 10, self.y * scale.th - 35 - signfont:getHeight())
        love.graphics.draw(icon_energy, self.x * scale.tw - 25, self.y * scale.th - 35 - signfont:getHeight(), 0, scale.x * 0.3, scale.y * 0.3)
        if effect.sampled then 
            love.graphics.print(effect.mineral, self.x * scale.tw + 10, self.y * scale.th - 35)
            love.graphics.draw(icon_mineral, self.x * scale.tw - 25, self.y * scale.th - 35, 0, scale.x * 0.3, scale.y * 0.3)
        else
            love.graphics.print("?", self.x * scale.tw, self.y * scale.th - 35)
        end
        
        love.graphics.setColor(color.selected)
    end
    
    -- draw actual mineral
    if not self.selected then love.graphics.setColor(color.white) end
    love.graphics.draw(img, self.x * scale.tw, self.y * scale.th, 0, scale.x * 0.4, scale.y * 0.4, img:getWidth() / 4, img:getHeight() / 4 )
    if self.active then
        --love.graphics.draw(arrow, self.x * scale.tw, self.y * scale.th, 0, scale.x * 0.4, scale.y * 0.4, arrow:getWidth() / 4, arrow:getHeight() / 1.2 )
    end
end
