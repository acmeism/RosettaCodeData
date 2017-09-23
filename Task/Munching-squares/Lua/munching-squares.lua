local clr =  {}
function drawMSquares()
    local pts = {}
    for j = 0, hei - 1 do
        for i = 0, wid - 1 do
            idx = bit.bxor( i, j ) % 256
            pts[1] = { i, j, clr[idx][1], clr[idx][2], clr[idx][3], 255 }
            love.graphics.points( pts )
        end
    end
end
function createPalette()
    for i = 0, 255 do
        clr[i] = { bit.band( i * 2.8, 255 ), bit.band( i * 3.2, 255 ), bit.band( i * 1.5, 255 ) }
    end
end
function love.load()
    wid, hei = love.graphics.getWidth(), love.graphics.getHeight()
    canvas = love.graphics.newCanvas( wid, hei )
    love.graphics.setCanvas( canvas ); love.graphics.clear()
    love.graphics.setColor( 255, 255, 255 )
    createPalette(); drawMSquares();
    love.graphics.setCanvas()
end
function love.draw()
    love.graphics.draw( canvas )
end
