
local screenone = love.graphics.newImage("res/screen1.png")
local screentwo = love.graphics.newImage("res/screen2.png")
local workspace = love.graphics.newImage("res/workspace.png")
local mouse = love.graphics.newImage("res/mouse2.png")

state_space = Gamestate.new()

local canvasx = nil
local canvasy = nil
local screen = nil
local desktop = nil

local workcanvas = nil

local function updateCanvasSize()
    screen = {
        w = love.graphics.getWidth(),
        h = love.graphics.getHeight(),
    }
    canvasx = screen.w / 1.92
    canvasy = screen.h / 2.08
end

function state_space:enter()
    updateCanvasSize()
    
    state_ingame:changeMouse()
    
    desktop = Desktop()
end

function state_space:update(dt)
    local timea = love.timer.getTime( )
    
    updateCanvasSize()
    state_ingame:update(dt, canvasx, canvasy)
    desktop:update(dt)
    
    local timeb = love.timer.getTime( )
    --if timeb - timea > 0.05 then print( "update:", timeb - timea ) end
end

function state_space:draw()
    
    local timea = love.timer.getTime( )
    
    love.mouse.setVisible(false)
    local canvas = state_ingame:draw(canvas)
    
    love.graphics.setBackgroundColor(0, 4, 13)
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.draw(canvas, 37, 97, 0, 1, 1, 0, 0, 0, -0.135)
    
    if not workcanvas then
        workcanvas = love.graphics.newCanvas(screen.w, screen.h)
        love.graphics.setCanvas(workcanvas)
        love.graphics.draw(screenone, 0, 0, 0, 0.9, 1)
        love.graphics.draw(screentwo, screenone:getWidth() * 0.9 + 10, 5, 0, 1, 0.98)
        love.graphics.draw(workspace, 0, 0)
        love.graphics.setCanvas()
    end
    love.graphics.draw(workcanvas)
    desktop:draw(screenone:getWidth(), screen)
    love.graphics.draw(mouse, 650 + 50 * love.mouse.getX() / screen.w, 500 + 50 * love.mouse.getY() / screen.h)
    
    local timeb = love.timer.getTime( )
    if timeb - timea > 0.05 then print( "draw:", timeb - timea ) end
    
end

function state_space:mousepressed( x, y, button )
    state_ingame:mousepressed( x, y, button )
end
