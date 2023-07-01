math.randomseed( os.time() )
colors, orig = { { 255, 0, 0 }, { 0, 255, 0 }, { 0, 0, 255 } }, {}

function love.load()
    wid, hei = love.graphics.getWidth(), love.graphics.getHeight()

    orig[1] = { wid / 2, 3 }
    orig[2] = { 3, hei - 3 }
    orig[3] = { wid - 3, hei - 3 }
    local w, h = math.random( 10, 40 ), math.random( 10, 40 )
    if math.random() < .5 then w = -w end
    if math.random() < .5 then h = -h end
    orig[4] = { wid / 2 + w, hei / 2 + h }

    canvas = love.graphics.newCanvas( wid, hei )
    love.graphics.setCanvas( canvas ); love.graphics.clear()
    love.graphics.setColor( 255, 255, 255 )
    love.graphics.points( orig )
    love.graphics.setCanvas()
end
function love.draw()
    local iter = 100 --> make this number bigger to speed up rendering
    for rp = 1, iter do
        local r, pts = math.random( 6 ), {}
        if r == 1 or r == 4 then
            pt = 1
        elseif r == 2 or r == 5 then
            pt = 2
        else
            pt = 3
        end
        local x, y = ( orig[4][1] + orig[pt][1] ) / 2, ( orig[4][2] + orig[pt][2] ) / 2
        orig[4][1] = x; orig[4][2] = y
        pts[1] = { x, y, colors[pt][1], colors[pt][2], colors[pt][3], 255 }
        love.graphics.setCanvas( canvas )
        love.graphics.points( pts )
    end
    love.graphics.setCanvas()
    love.graphics.draw( canvas )
end
