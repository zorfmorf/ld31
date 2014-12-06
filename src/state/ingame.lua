
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

local function addEntity(entity)
    
    if not tilegrid then
        tilegrid = {}
        for i=0,30 do
            tilegrid[i] = {}
            for j=0,15 do
                tilegrid[i][j] = j > 3
            end
        end
    end
    
    if tilegrid[entity.x] and tilegrid[entity.x][entity.y] then
        table.insert(entities, entity)
        tilegrid[entity.x][entity.y] = false
        if entity.lander then
            for k=-2,1 do
                for l=-2,1 do
                    if tilegrid[entity.x+k] and tilegrid[entity.x+k][entity.y+l] then
                        tilegrid[entity.x+k][entity.y+l] = false
                    end
                end
            end
        end
        return true
    end
    return false
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
    addEntity(lander)
    addEntity(probe)
    addEntity(Mineral(2, 5, "mineral_blue"))
    addEntity(Mineral(22, 13, "mineral_orange"))
    
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
    research_enabled = false
    solar_panel_extended = false
    allow_solarpanels = false
    buildmode = nil
end


function state_ingame:update(dt)
    updateParameters()
    if not buildmode then cycleEntities(false) end
    for i,entity in pairs(entities) do
        entity:update(dt)
    end
    -- sort entities by y value
    table.sort(entities, function(a,b) return a.y < b.y end)
    
    taskHandler.update(dt)
    
    -- research bar
    if research_enabled and not buildmode and not probe.sample then
        gui.group.push{grow = "down", pos = {30, screen.h - 30}}
        if not solar_panel_extended and stat.minerals >= 2 and not lander.solar then 
            if gui.Button{text="Solar Array"} then
                lander:action("solar")
            end
        end
        if allow_solarpanels and stat.minerals >= 3 then
            if gui.Button{text="Solar Panel"} then
                buildmode = Solarpanel(-1,-1)
                stat.minerals = stat.minerals - 3
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
    if buildmode then
        local x,y = love.mouse.getPosition()
        x = x - (screen.w / translate.x)
        y = y - (screen.h / translate.y)
        x = math.floor(x / scale.tw)
        y = math.floor(y / scale.th)
        love.graphics.setColor(color.red)
        if tilegrid[x] and tilegrid[x][y] then love.graphics.setColor(color.selected) end
        love.graphics.rectangle("fill", x * scale.tw,y * scale.th, scale.tw, scale.th)
    end
    
    for i,entity in pairs(entities) do
        entity:draw(scale)
    end
    
    drawHud()
end

function state_ingame:mousepressed( x, y, button )
    if button == "l" then
        if buildmode then 
            x = x - (screen.w / translate.x)
            y = y - (screen.h / translate.y)
            buildmode.x = math.floor(x / scale.tw)
            buildmode.y = math.floor(y / scale.th)
            if addEntity(buildmode) then
                buildmode:action()
            end
            buildmode = nil
        else
            cycleEntities(button)
        end
    end
end
