
state_ingame = Gamestate.new()

local bkg = love.graphics.newImage("res/bkg.png")
local bkg_sky = love.graphics.newImage("res/bkg_sky.png")

local mouse = love.graphics.newImage("res/mouse.png")
local plus = love.graphics.newImage("res/plus.png")
local icon_scanner = love.graphics.newImage("res/icon_scanner.png")
local icon_panel = love.graphics.newImage("res/icon_panel.png")
local icon_antenna = love.graphics.newImage("res/icon_antenna.png")
local sun = love.graphics.newImage("res/sun.png")

local canvas = nil

local entities = nil

local translate = { x = 100, y = 3}

local timesincelastsort = 0

local mousemod = 1


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
    x = x * scale.x * mousemod - (screen.w / translate.x)
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


function state_ingame:changeMouse()
    mousemod = 2
end

function state_ingame:enter()
    
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
    addEntity(Mineral(3, 9, "mineral_blue"))
    addEntity(Mineral(27, 7, "mineral_orange"))
    addEntity(Mineral(18, 11, "mineral_brown"))
    
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
    solar_panel_built = false
    antenna_built = false
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
    love.graphics.setColor(color.white)
    love.graphics.setFont(font)
    
    if research_enabled and not buildmode and not probe.sample then
        
        local mx, my = love.mouse.getPosition()
        mx = mx * scale.x * mousemod
        my = my * scale.y
        
        
        -- first build icon
        if not solar_panel_extended and stat.minerals >= 2 and not lander.solar then 
            if mx >= 30 and mx <= 30 + plus:getWidth() and my >= screen.h - 5 - plus:getHeight() then
                love.graphics.setColor(color.black)
                love.graphics.print("Extend solar panel", 30, screen.h - 5 - plus:getHeight() - font:getHeight() - 5)
                love.graphics.setColor(color.selected)
            end
            love.graphics.draw(icon_panel, 30, (screen.h - 5) - plus:getHeight())
        else
            if solar_panel_extended and stat.minerals >= 2 then
                if mx >= 30 and mx <= 30 + plus:getWidth() and my >= screen.h - 5 - plus:getHeight() then
                    love.graphics.setColor(color.black)
                    love.graphics.print("Build antenna", 30, screen.h - 5 - plus:getHeight() - font:getHeight() - 5)
                    love.graphics.setColor(color.selected)
                end
                love.graphics.draw(icon_antenna, 30, (screen.h - 5) - plus:getHeight())
            end
        end
        
        
        -- second build icon
        love.graphics.setColor(color.white)
        if not auspex_built and stat.minerals >= 3 and stat.science > 10 and not lander.auspex then 
            if mx >= 40 + plus:getWidth() and mx <= 40 + plus:getWidth() * 2 and 
                                            my >= screen.h - 5 - plus:getHeight() then
                love.graphics.setColor(color.black)
                love.graphics.print("Build scanner", 40 + plus:getWidth(), 
                                screen.h - 5 - plus:getHeight() - font:getHeight() - 5)
                love.graphics.setColor(color.selected)
            end
            love.graphics.draw(icon_scanner, 40 + plus:getWidth(), screen.h - 5 - plus:getHeight())
        end
        
        
        -- third build icon
        love.graphics.setColor(color.white)
        if allow_solarpanels and stat.minerals >= 3 then
            if mx >= 50 + plus:getWidth() * 2 and mx <= 50 + plus:getWidth() * 3 and 
                                            my >= screen.h - 5 - plus:getHeight() then
                love.graphics.setColor(color.black)
                love.graphics.print("Build solar pannel", 50 + plus:getWidth() * 2, 
                                screen.h - 5 - plus:getHeight() - font:getHeight() - 5)
                love.graphics.setColor(color.selected)
            end
            love.graphics.draw(icon_panel, 50 + plus:getWidth() * 2, screen.h - 5 - plus:getHeight())
        end
        
    end
end


function state_ingame:draw(delta)
    
    if not canvas or not (canvas:getWidth() == screen.w and canvas:getHeight() == screen.h) then
        canvas = love.graphics.newCanvas(screen.w, screen.h)
    end
    
    love.mouse.setVisible(false)    
    love.graphics.setCanvas(canvas)
    love.graphics.setColor(color.white)
    
    love.graphics.draw(bkg_sky, 0, 0, 0, scale.x, scale.y)
    love.graphics.draw(sun, screen.w * (1 - 0.2 * math.min(delta / 20, 1)) * scale.x, screen.h * (0.4 - 0.2 * math.min(delta / 20, 1)) * scale.y, 0, scale.x, scale.y, bkg_sky:getWidth() * scale.x * 0.5, bkg_sky:getHeight() * scale.y * 0.5)
    love.graphics.draw(bkg, 0, 0, 0, scale.x, scale.y)
    
    
    love.graphics.translate( screen.w / translate.x,  screen.h / translate.y)
    love.graphics.setColor(color.black)
    if buildmode then
        local x,y = love.mouse.getPosition()
        x = x * scale.x * mousemod - (screen.w / translate.x)
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
    
    love.graphics.origin()
    
    drawHud()
    
    love.graphics.setColor(color.white)
    local mx, my = love.mouse.getPosition()
    mx = mx * scale.x * mousemod
    my = my * scale.y
    love.graphics.draw(mouse, mx, my, 0, 0.5, 0.5)
    
    love.graphics.setCanvas()
    
    return canvas
end

function state_ingame:mousepressed( x, y, button )
    if button == "l" then
        if buildmode then 
            x = x * scale.x * mousemod - (screen.w / translate.x)
            y = y * scale.y - (screen.h / translate.y)
            buildmode.x = math.floor(x / scale.tw)
            buildmode.y = math.floor(y / scale.th)
            if addEntity(buildmode) then
                buildmode:action()
            end
            buildmode = nil
        else
            local mx = x * scale.x * mousemod
            local my = y * scale.y
            
            if mx >= 30 and mx <= 30 + plus:getWidth() and my >= screen.h - 5 - plus:getHeight() then
                if solar_panel_extended then
                    buildmode = Antenna(-1,-1)
                    stat.minerals = stat.minerals - 2
                else
                    lander:action("solar")
                end
                return
            end
            
            if mx >= 40 + plus:getWidth() and mx <= 40 + plus:getWidth() * 2 and 
                                            my >= screen.h - 5 - plus:getHeight() then
                lander:action("auspex")
                return
            end
            
            if mx >= 50 + plus:getWidth() * 2 and mx <= 50 + plus:getWidth() * 3 and 
                                            my >= screen.h - 5 - plus:getHeight() then
                buildmode = Solarpanel(-1,-1)
                stat.minerals = stat.minerals - 3
                return
            end
            
            cycleEntities(button)
        end
    end
end
