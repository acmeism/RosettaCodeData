function prod( a, b )
    local rt, l = {}, 1
    for m = 1, #a do
        for p = 1, #b do
            rt[l] = {}
            for n = 1, #a[m] do
                for q = 1, #b[p] do
                    table.insert( rt[l], a[m][n] * b[p][q] )
                end
            end
            l = l + 1
        end
    end
    return rt
end
function love.load()
    wid, hei = love.graphics.getWidth(), love.graphics.getHeight()
    canvas = love.graphics.newCanvas( wid, hei )
    mA = { {0,1,0}, {1,1,1}, {0,1,0} }; mB = { {1,0,1}, {0,1,0}, {1,0,1} }
    mC = { {1,1,1}, {1,0,1}, {1,1,1} }; mD = { {1,1,1}, {0,1,0}, {1,1,1} }
end
function drawFractals( m )
    love.graphics.setCanvas( canvas )
    love.graphics.clear()
    love.graphics.setColor( 255, 255, 255 )
    for j = 1, #m do
        for i = 1, #m[j] do
            if m[i][j] == 1 then
                love.graphics.points( i * .1, j * .1 )
            end
        end
    end
    love.graphics.setCanvas()
end
function love.keypressed( key, scancode, isrepeat )
    local t = {}
    if key == "a" then
        print( "Build Vicsek fractal I" ); t = mA
    elseif key == "b" then
        print( "Build Vicsek fractal II" ); t = mB
    elseif key == "c" then
        print( "Sierpinski carpet fractal" ); t = mC
    elseif key == "d" then
        print( "Build 'H' fractal" ); t = mD
    else return
    end
    for i = 1, 3 do t = prod( t, t ) end
    drawFractals( t )
end
function love.draw()
    love.graphics.draw( canvas )
end
