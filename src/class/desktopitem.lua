
local chatfont = love.graphics.newFont("font/Orbitron Medium.ttf", 14)

Desktopitem = Class {
    init = function(self, x, y, image)
        self.x = x
        self.y = y
        self.image = image
        self.visible = true
    end
}

-- return true if request top
function Desktopitem:update(dt)
    return false
end


function Desktopitem:draw(x, y)
    love.graphics.draw(self.image, x, y)
end

------------ chat----------------------------
Chatbox = Class{
    __includes = Desktopitem,
    init = function(self, x, y, image, message)
        Desktopitem.init(self, x, y, image)
        self.messages = {}
        self.messages[0] = "Boss: You are fired!"
        self.messages[1] = "Boss: This is my last warning!!!"
        self.messages[2] = "Boss: You are the worst!"
        self.messages[3] = "Boss: Get off your lazy ass!"
        self.messages[4] = "Boss: You haven't written in a while..."
        self.messages[5] = "Boss: Are you working?"
        self.messages[6] = "Boss: Work is good for you!"
        
        self.work = player.stats.work
        self.current = self.messages[self.work]
    end
}

-- return true if request top
function Chatbox:update(dt)
    
    -- if player lost work, update message
    if self.work > player.stats.work then
        self.work = player.stats.work
        self.current = self.messages[self.work]
        audio_message:play()
        return true
    end
    
    -- if player worked, update with positive message
    if self.work < player.stats.work then
        self.current = self.messages[6]
    end
    
    self.work = player.stats.work
    return false
end

function Chatbox:draw(x, y)
    love.graphics.draw(self.image, x, y)
    love.graphics.setColor(0, 0, 0, 150)
    love.graphics.setFont(chatfont)
    local wid, wrap = chatfont:getWrap(self.messages[self.work], self.image:getWidth() - 20)
    love.graphics.printf(self.current, x + 8, y + self.image:getHeight() - chatfont:getHeight() * wrap - 5, self.image:getWidth() - 20, "left")
    love.graphics.setColor(255, 255, 255, 255)
end

------------ Wörk ----------------------------

Workbox = Class{
    __includes = Desktopitem,
    init = function(self, x, y, image, message)
        Desktopitem.init(self, x, y, image)
        self.input = "Write something"
        self.count = 0
    end
}

-- return true if request top
function Workbox:update(dt)
    if self.count > 20 then
        self.count = 0
        player.increaseWork()
    end
    local width, wrap = workfont:getWrap(self.input, self.image:getWidth() - 20)
    if wrap > 14 then
        state_win:work()
        Gamestate.switch(state_win)
    end
    return false
end

function Workbox:draw(x, y)
    love.graphics.draw(self.image, x, y)
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.setFont(workfont)
    love.graphics.printf(self.input, x + 8, y + 10, self.image:getWidth() - 20, "left")
    love.graphics.setColor(255, 255, 255, 255)
end

function Workbox:addInput(key, isrepeat)
    if not isrepeat then
        self.count = self.count + 1
        self.input = self.input .. key
        if math.random(1, 10) == 10 then self.input = self.input .. " " end
        player.workcd()
    end
end
