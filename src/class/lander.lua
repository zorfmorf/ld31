
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
        table.insert(self.texts, 1, {"+1 Minerals", 0})
        stat.minerals = stat.minerals + 1
        for i,sample in pairs(self.samples) do
            if psample == sample then return false end
        end
        table.insert(self.samples, psample)
        table.insert(self.texts, 1, {"New Sample! +10 Science", 0})
        stat.science = stat.science + 10
        return true
    end
    
    return false
end

-- on click event
function Lander:action()
    probe:register(self)
    self.active = true
end

function Lander:draw(scale)
    local img = img1
    love.graphics.draw(img, self.x * scale.tw, self.y * scale.th, 0, scale.x * 0.4, scale.y * 0.4, (img:getWidth() / 2.5), (img:getHeight() / 1.5))
    love.graphics.setFont(landerfont)
    for i,line in ipairs(self.texts) do
        love.graphics.setColor(0, 0, 0, math.max(0, 255 - line[2] * 100))
        love.graphics.print(line[1], self.x * scale.tw, self.y * scale.th - line[2] * 5 - i * font:getHeight(), 0, scale.x * 0.4, scale.y * 0.4, img:getWidth() / 4, img:getHeight() / 1.5)
    end
end
