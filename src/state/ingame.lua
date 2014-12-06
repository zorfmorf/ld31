
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
                    entity:action(action)
                else
                    entity.selected = true
                end
            end
        end
        
        if math.floor(entity.x + 0.5) == x and math.floor(entity.y + 0.5) == y then 
            if action then 
                entity:action(action)
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
        selected = {170, 249, 145, 255},
        red = {166, 90, 93, 255}
    }
    
    lander = Lander(15, 4)
    probe = Probe(10, 5)
    
    entities = {}
    table.insert(entities, lander)
    table.insert(entities, probe)
    table.insert(entities, Mineral(2, 5, "mineral_blue"))
    table.insert(entities, Mineral(22, 13, "mineral_orange"))
    
    -- sort entities by y value
    table.sort(entities, function(a,b) return a.y < b.y end)
    
    taskHandler.init()
    dayHandler.init()
    
    -- ressources
    stat = {
        science = 0,
        minerals = 0,
        energy = 10,
        energypd = 0,
        day = 1
    }
    
    show_menu = false
    research_enabled = true
end


function state_ingame:update(dt)
    updateParameters()
    cycleEntities(false)
    for i,entity in pairs(entities) do
        entity:update(dt)
    end
    -- sort entities by y value
    table.sort(entities, function(a,b) return a.y < b.y end)
    
    taskHandler.update(dt)
    
    -- research bar
    if research_enabled then
        gui.group.push{grow = "down", pos = {screen.w / 2 - 160, 0}}
        
        if gui.Button{ text = "Lander Action"} then
            show_menu = not show_menu
        end
        
        -- level 1 research
        if show_menu then
            
            local research = dayHandler.getResearch()
            for i,row in ipairs(research) do
                gui.group.push{grow = "right", pos = {-75, 0}}
                
                for j,entry in ipairs(row) do
                    if gui.Button{ id=entry.id, text = entry.name} then
                        -- research action
                    end
                end
                
                gui.group.pop{}
            end
            gui.group.pop{}
            
            local mx, my = love.mouse.getPosition()
            for i,row in ipairs(research) do
                for j,entry in ipairs(row) do
                    if gui.mouse.isHot(entry.id) then
                        gui.Label{text = entry.desc, pos = {mx + 10,my - 20}}
                    end
                end
            end
        end
    end
end

local function drawHud()
    love.graphics.origin()
    love.graphics.setColor(color.black)
    love.graphics.setFont(font)
    
    if stat.science then 
        love.graphics.print("Science:", 5, 5)
        love.graphics.printf(stat.science, 5, 5, 130, "right") 
    end
    if stat.minerals then 
        love.graphics.print("Minerals:", 5, 10 + font:getHeight())
        love.graphics.printf(stat.minerals, 5, 10 + font:getHeight(), 130, "right") 
    end
    if stat.energy then 
        love.graphics.print("Energy:", 5, 15 + font:getHeight() * 2)
        love.graphics.printf(stat.energy, 5, 15 + font:getHeight() * 2, 130, "right")
        love.graphics.printf(stat.energypd, 5, 15 + font:getHeight() * 2, 160, "right")
    end
    if DEBUG then love.graphics.print("FPS: "..love.timer.getFPS(), 5, 20 + font:getHeight() * 3) end
    
    love.graphics.print("Day "..stat.day, screen.w - 300, 5)
    local list = taskHandler.getTasklist()
    for i,task in pairs(list) do
        local line = task.text
        if task.finished then line = "[x] "..line else line = "[  ] "..line end
        love.graphics.print(line, screen.w - 300, i * font:getHeight() + 10)
    end
    
    gui.core.draw()
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
    
    for i,entity in pairs(entities) do
        entity:draw(scale)
    end
    
    drawHud()
end

function state_ingame:mousepressed( x, y, button )
    if button == "l" or button == "r" then cycleEntities(button) end
end
