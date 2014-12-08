
local lander = love.graphics.newImage("res/lander.png")
local solar = love.graphics.newImage("res/lander_solar.png")
local auspex = love.graphics.newImage("res/lander_auspex.png")

Lander = Class {
    init = function(self, x, y)
        self.x = x
        self.y = y
        self.selected = false
        self.lander = true
        self.samples = {}
        self.work = 3
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
        audio_processed:play()
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
        
    if self.solar then
        solar_panel_extended = true
        stat.energypd = stat.energypd + 1
        self.solar = nil
    end
    
    if self.auspex then
        auspex_built = true
        audio_sonar:play()
        self.auspex = nil
    end
    
    dayHandler.free()
    return false
end

-- on click event
function Lander:action(button)
    
    if button == "solar" and dayHandler.lock() then
        probe:register(self)
        self.solar = true
        stat.minerals = stat.minerals - 2
    end
    
    if button == "auspex" and dayHandler.lock() then
        probe:register(self)
        self.auspex = true
        stat.minerals = stat.minerals - 3
    end
        
    -- if probe has mineral deliver it
    if probe.sample and dayHandler.lock() then
        probe:register(self)
    end
end

function Lander:draw(scale)
    
    -- draw lander
    love.graphics.setColor(color.white)    
    if self.selected and probe.sample then love.graphics.setColor(color.selected) end
    love.graphics.draw(lander, self.x * scale.tw, self.y * scale.th, 0, scale.x * 0.4, scale.y * 0.4, (lander:getWidth() / 2.5), (lander:getHeight() / 1.5))
    if solar_panel_extended then
        love.graphics.draw(solar, self.x * scale.tw, self.y * scale.th, 0, scale.x * 0.4, scale.y * 0.4, (solar:getWidth() / 2.5), (solar:getHeight() / 1.5))
    end
    if auspex_built then
        love.graphics.draw(auspex, self.x * scale.tw, self.y * scale.th, 0, scale.x * 0.4, scale.y * 0.4, (auspex:getWidth() / 2.5), (auspex:getHeight() / 1.5))
    end
    
    -- draw hover texts
    love.graphics.setFont(landerfont)
    for i,line in ipairs(self.texts) do
        love.graphics.setColor(0, 0, 0, math.max(0, 255 - line[2] * 100))
        love.graphics.print(line[1], self.x * scale.tw, self.y * scale.th - line[2] * 5 - i * landerfont:getHeight() * 0.5, 0, scale.x * 0.4, scale.y * 0.4, lander:getWidth() / 4, lander:getHeight() / 1.5)
    end
end
