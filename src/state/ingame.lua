
state_ingame = Gamestate.new()

local bkg = nil

local mouse = love.graphics.newImage("res/mouse.png")

local entities = nil

local translate = { x = 100, y = 3}

local timesincelastsort = 0

-- we want to allow resizing at all times
local function updateParameters(cx, cy)
    screen = {
        w = love.graphics.getWidth(),
        h = love.graphics.getHeight()
    }
    
    if cx and cy then
        screen.w = cx
        screen.h = cy
    end
    
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
    x = x * scale.x - (screen.w / translate.x)
    y = y * scale.y - (screen.h / translate.y)
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

function addEntity(entity)
    
    if not tilegrid then
        tilegrid = {}
        for i=0,30 do
            tilegrid[i] = {}
            for j=0,15 do
                tilegrid[i][j] = j > 6
            end
        end
    end
    
    if entity.destroys then
        for i,cand in pairs(entities) do
            if entity.x == cand.x and entity.y == cand.y then
                table.remove(entities, i)
                table.insert(entities, entity)
                return
            end
            tilegrid[entity.x][entity.y] = false
        end
        table.insert(entities, entity)
        return
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
    
    lander = Lander(15, 7)
    probe = Probe(10, 8)
    
    entities = {}
    addEntity(lander)
    addEntity(probe)
    addEntity(Mineral(2, 9, "mineral_blue"))
    addEntity(Mineral(22, 13, "mineral_orange"))
    addEntity(Mineral(12, 11, "mineral_brown"))
    
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
    auspex_built = false
    allow_solarpanels = false
    buildmode = nil
end


function state_ingame:update(dt, cx, cy)
    
    updateParameters(cx, cy)
    if not buildmode then cycleEntities(false) end
    for i,entity in pairs(entities) do
        entity:update(dt)
    end
    
    timesincelastsort = timesincelastsort + dt
    if timesincelastsort > 0.3 then
        -- sort entities by y value
        table.sort(entities, function(a,b) return a.y < b.y end)
        timesincelastsort = 0
    end
    
    taskHandler.update(dt)
end

local function drawHud()
    
    love.graphics.origin()
    love.graphics.setColor(color.black)
    love.graphics.setFont(font)
    
    if research_enabled and not buildmode and not probe.sample then
        --[[
        gui.group.push{grow = "down", pos = {30, screen.h - 30}}
        if not solar_panel_extended and stat.minerals >= 2 and not lander.solar then 
            if gui.Button{text="Solar Array"} then
                lander:action("solar")
            end
        end
        if not auspex_built and stat.minerals >= 3 and stat.science > 10 and not lander.auspex then 
            if gui.Button{text="Auspex"} then
                lander:action("auspex")
            end
        end
        if allow_solarpanels and stat.minerals >= 3 then
            if gui.Button{text="Solar Panel"} then
                buildmode = Solarpanel(-1,-1)
                stat.minerals = stat.minerals - 3
            end
        end
        ]]--
    end
end


function state_ingame:draw(canvas)
    
    love.mouse.setVisible(false)
    
    love.graphics.setCanvas(canvas)
    
    love.graphics.setColor(color.white)
    love.graphics.draw(bkg, 0, 0, 0, scale.x, scale.y)
    
    love.graphics.translate( screen.w / translate.x,  screen.h / translate.y)
    
    love.graphics.setColor(color.black)
    if buildmode then
        local x,y = love.mouse.getPosition()
        x = x * scale.x - (screen.w / translate.x)
        y = y * scale.y - (screen.h / translate.y)
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
    
    love.graphics.setColor(color.white)
    local mx, my = love.mouse.getPosition()
    mx = mx * scale.x
    my = my * scale.y
    love.graphics.draw(mouse, mx, my, 0, 0.5, 0.5)
    
    love.graphics.setCanvas()
    
    return canvas
end

function state_ingame:mousepressed( x, y, button )
    if button == "l" then
        if buildmode then 
            x = x * scale.x - (screen.w / translate.x)
            y = y * scale.y - (screen.h / translate.y)
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
