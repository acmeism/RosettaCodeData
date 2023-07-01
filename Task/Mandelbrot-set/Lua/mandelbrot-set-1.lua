local maxIterations = 250
local minX, maxX, minY, maxY = -2.5, 2.5, -2.5, 2.5
local miX, mxX, miY, mxY
function remap( x, t1, t2, s1, s2 )
    local f = ( x - t1 ) / ( t2 - t1 )
    local g = f * ( s2 - s1 ) + s1
    return g;
end
function drawMandelbrot()
    local pts, a, as, za, b, bs, zb, cnt, clr = {}
    for j = 0, hei - 1 do
        for i = 0, wid - 1 do
            a = remap( i, 0, wid, minX, maxX )
            b = remap( j, 0, hei, minY, maxY )
            cnt = 0; za = a; zb = b
            while( cnt < maxIterations ) do
                as = a * a - b * b; bs = 2 * a * b
                a = za + as; b = zb + bs
                if math.abs( a ) + math.abs( b ) > 16 then break end
                cnt = cnt + 1
            end
            if cnt == maxIterations then clr = 0
            else clr = remap( cnt, 0, maxIterations, 0, 255 )
            end
            pts[1] = { i, j, clr, clr, 0, 255 }
            love.graphics.points( pts )
        end
    end
end
function startFractal()
    love.graphics.setCanvas( canvas ); love.graphics.clear()
    love.graphics.setColor( 255, 255, 255 )
    drawMandelbrot(); love.graphics.setCanvas()
end
function love.load()
    wid, hei = love.graphics.getWidth(), love.graphics.getHeight()
    canvas = love.graphics.newCanvas( wid, hei )
    startFractal()
end
function love.mousepressed( x, y, button, istouch )
    if button ==  1 then
        startDrag = true; miX = x; miY = y
    else
        minX = -2.5; maxX = 2.5; minY = minX; maxY = maxX
        startFractal()
        startDrag = false
    end
end
function love.mousereleased( x, y, button, istouch )
    if startDrag then
        local l
        if x > miX then mxX = x
        else l = x; mxX = miX; miX = l
        end
        if y > miY then mxY = y
        else l = y; mxY = miY; miY = l
        end
        miX = remap( miX, 0, wid, minX, maxX )
        mxX = remap( mxX, 0, wid, minX, maxX )
        miY = remap( miY, 0, hei, minY, maxY )
        mxY = remap( mxY, 0, hei, minY, maxY )
        minX = miX; maxX = mxX; minY = miY; maxY = mxY
        startFractal()
    end
end
function love.draw()
    love.graphics.draw( canvas )
end
