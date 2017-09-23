RIGHT, LEFT, UP, DOWN = 1, 2, 4, 8
function drawFractals( w )
    love.graphics.setCanvas( canvas )
    love.graphics.clear()
    love.graphics.setColor( 255, 255, 255 )
    local dir, facing, lineLen, px, py, c = RIGHT, UP, 1, 10, love.graphics.getHeight() - 20, 1
    local x, y = 0, -lineLen
    local pts = {}
    table.insert( pts, px + .5 ); table.insert( pts, py + .5 )
    for i = 1, #w do
        px = px + x; table.insert( pts, px + .5 )
        py = py + y; table.insert( pts, py + .5 )
        if w:sub( i, i ) == "0" then
            if c % 2 == 1 then dir = RIGHT else dir = LEFT end
            if facing == UP then
                if dir == RIGHT then x = lineLen; facing = RIGHT
                else x = -lineLen; facing = LEFT end; y = 0
            elseif facing == RIGHT then
                if dir == RIGHT then y = lineLen; facing = DOWN
                else y = -lineLen; facing = UP end; x = 0
            elseif facing == DOWN then
                if dir == RIGHT then x = -lineLen; facing = LEFT
                else x = lineLen; facing = RIGHT end; y = 0
            elseif facing == LEFT then
                if dir == RIGHT then y = -lineLen; facing = UP
                else y = lineLen; facing = DOWN end; x = 0
            end
        end
        c = c + 1
    end
    love.graphics.line( pts )
    love.graphics.setCanvas()
end
function createWord( wordLen )
    local a, b, w = "1", "0"
    repeat
        w = b .. a; a = b; b = w; wordLen = wordLen - 1
    until wordLen == 0
    return w
end
function love.load()
    wid, hei = love.graphics.getWidth(), love.graphics.getHeight()
    canvas = love.graphics.newCanvas( wid, hei )
    drawFractals( createWord( 21 ) )
end
function love.draw()
    love.graphics.draw( canvas )
end
