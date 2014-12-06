
state_ingame = Gamestate.new()

local bkg = nil

local entities = nil

local translate = { x = 100, y = 3}

-- we want to allow resizing at all times
local function updateParameters()
    screen = {
        w = love.graphics.getWidth(),
        h = love.graphics.getHeight()
    }
    
    local x = screen.w / bkg:getWidth()
    local y = screen.h / bkg:getHeight()
    
    scale = {
        x = x,
        y = y,
        tw = 32 * x,
        th = 32 * y
    }
end

-- cycle entities and either highlight them or execute on click action
local function cycleEntities(action)
    local x,y = love.mouse.getPosition()
    x = x - (screen.w / translate.x)
    y = y - (screen.h / translate.y)
    x = math.floor(x / scale.tw)
    y = math.floor(y / scale.th)
    
    for i,entity in pairs(entities) do
        
        if not action then entity.selected = false end
        
        if entity.lander then 
            if math.abs(entity.x - x) < 2 and entity.y - y < 3 and entity.y - y > -1 then 
                if action then 
                    entity:action()
                else
                    entity.selected = true
                end
            end
        end
        
        if math.floor(entity.x + 0.5) == x and math.floor(entity.y + 0.5) == y then 
            if action then 
                entity:action()
            else
                entity.selected = true
            end
        end
    end
end


function state_ingame:enter()
    bkg = love.graphics.newImage("res/bkg.png")
    
    updateParameters()
    
    color = {
        white = {255, 255, 255, 255},
        black = {0, 0, 0, 255},
        selected = {170, 249, 145, 255}
    }
    
    lander = Lander(15, 7)
    probe = Probe(10, 3)
    
    entities = {}
    table.insert(entities, lander)
    table.insert(entities, probe)
    table.insert(entities, Mineral(2, 5, 1))
    table.insert(entities, Mineral(26, 6, 1))
    table.insert(entities, Mineral(22, 13, 2))
    
    -- sort entities by y value
    table.sort(entities, function(a,b) return a.y < b.y end)
end


function state_ingame:update(dt)
    updateParameters()
    cycleEntities(false)
    for i,entity in pairs(entities) do
        entity:update(dt)
    end
    -- sort entities by y value
    table.sort(entities, function(a,b) return a.y < b.y end)
end


function state_ingame:draw()
    love.graphics.setBackgroundColor(color.white)
    love.graphics.setColor(color.white)
    love.graphics.draw(bkg, 0, 0, 0, scale.x, scale.y)
    
    love.graphics.translate( screen.w / translate.x,  screen.h / translate.y)
    
    love.graphics.setColor(color.black)
    for i=0,30 do
        for j=0,15 do
            --love.graphics.rectangle("line", i * scale.tw, j * scale.th, scale.tw, scale.th)
        end
    end
    
    love.graphics.setColor(color.white)
    for i,entity in pairs(entities) do
        if entity.selected then love.graphics.setColor(color.selected) end
        entity:draw(scale)
        love.graphics.setColor(color.white)
    end
    
end

function state_ingame:mousepressed( x, y, button )
    if button == "l" then cycleEntities(true) end
end
