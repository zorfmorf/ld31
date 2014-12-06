
local img0 = love.graphics.newImage("res/lander0.png")
local img1 = love.graphics.newImage("res/lander1.png")

Lander = Class {
    init = function(self, x, y)
        self.x = x
        self.y = y
        self.selected = false
        self.lander = true
        self.samples = {}
        self.work = 2
        self.texts = {}
    end
}

function Lander:update(dt)
    for i,line in ipairs(self.texts) do
        line[2] = line[2] + dt
    end
    if #self.texts > 0 and self.texts[#self.texts][2] > 3 then table.remove(self.texts) end
end

function Lander:finishWork()
    local psample = probe.sample
    probe.sample = nil
    
    if psample then
        local effect = dayHandler.getEffect(psample)
        table.insert(self.texts, 1, {"+"..effect.mineral.." Minerals", 0})
        stat.minerals = stat.minerals + effect.mineral
        for i,sample in pairs(self.samples) do
            if psample == sample then dayHandler.free() return false end
        end
        table.insert(self.samples, psample)
        table.insert(self.texts, 1, {"New Sample! +"..effect.science.." Science", 0})
        effect.sampled = true
        stat.science = stat.science + effect.science
        dayHandler.free()
        return true
    end
    
    dayHandler.free()
    return false
end

-- on click event
function Lander:action(button)
        
    -- if probe has mineral deliver it
    if probe.sample and dayHandler.lock() then
        probe:register(self)
        self.active = true
    else
       -- if probe doesnt have sample, execute click event 
        
    end
end

function Lander:draw(scale)
    local img = img0
    
    -- draw action preview
    if self.selected and not probe.sample then
        love.graphics.setColor(color.white)
        love.graphics.rectangle("fill", self.x * scale.tw + 60, self.y * scale.th - 75, 100, 100)
        love.graphics.setColor(color.black)
        love.graphics.rectangle("line", self.x * scale.tw + 60, self.y * scale.th - 75, 100, 100)
        
        love.graphics.setColor(color.white)
        love.graphics.draw(icon_mousel, self.x * scale.tw + 60, self.y * scale.th - 75, 0, scale.x * 0.3, scale.y * 0.3)
        love.graphics.draw(icon_mouser, self.x * scale.tw + 60, self.y * scale.th - 25, 0, scale.x * 0.3, scale.y * 0.3)
        love.graphics.setFont(signfont2)
        love.graphics.setColor(color.black)
        love.graphics.print("Research", self.x * scale.tw + 100, self.y * scale.th - 75)
        love.graphics.print("Build", self.x * scale.tw + 100, self.y * scale.th - 25)
    end
    
    -- draw lander
    love.graphics.setColor(color.white)    
    if self.selected then love.graphics.setColor(color.selected) end
    love.graphics.draw(img, self.x * scale.tw, self.y * scale.th, 0, scale.x * 0.4, scale.y * 0.4, (img:getWidth() / 2.5), (img:getHeight() / 1.5))
    love.graphics.setFont(landerfont)
    for i,line in ipairs(self.texts) do
        love.graphics.setColor(0, 0, 0, math.max(0, 255 - line[2] * 100))
        love.graphics.print(line[1], self.x * scale.tw, self.y * scale.th - line[2] * 5 - i * font:getHeight(), 0, scale.x * 0.4, scale.y * 0.4, img:getWidth() / 4, img:getHeight() / 1.5)
    end
end
