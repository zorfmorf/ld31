
local chatfont = love.graphics.newFont("font/Orbitron Medium.ttf", 14)

Desktopitem = Class {
    init = function(self, x, y, image)
        self.x = x
        self.y = y
        self.image = image
        self.visible = true
    end
}

function Desktopitem:update(dt)
    
end


function Desktopitem:draw(x, y)
    love.graphics.draw(self.image, x, y)
end

-- chat

Chatbox = Class{
    __includes = Desktopitem,
    init = function(self, x, y, image, message)
        Desktopitem.init(self, x, y, image)
        self.message = message
    end
}

function Chatbox:draw(x, y)
    love.graphics.draw(self.image, x, y)
    love.graphics.setColor(0, 0, 0, 150)
    love.graphics.setFont(chatfont)
    local wid, wrap = chatfont:getWrap(self.message, self.image:getWidth() - 20)
    love.graphics.printf(self.message, x + 8, y + self.image:getHeight() - chatfont:getHeight() * wrap - 5, self.image:getWidth() - 20, "left")
    love.graphics.setColor(255, 255, 255, 255)
end
