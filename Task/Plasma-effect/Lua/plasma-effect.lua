_ = love.graphics
p1, p2, points = {}, {}, {}

function hypotenuse( a, b )
    return a * a + b * b
end
function love.load()
    size = _.getWidth()
    currentTime, doub, half = 0, size * 2, size / 2
    local b1, b2

    for j = 0, size * 2 do
        for i = 0, size * 2 do
            b1 = math.floor( 128 + 127 * ( math.cos( math.sqrt( hypotenuse( size - j , size - i ) ) / 64 ) ) )
            b2 = math.floor( ( math.sin( ( math.sqrt( 128.0 + hypotenuse( size - i, size - j ) ) - 4.0 ) / 32.0 ) + 1 ) * 90 )
            table.insert( p1, b1 ); table.insert( p2, b2 )
        end
    end
end
function love.draw()
    local a, c1, c2, c3, s1, s2, s3
    currentTime = currentTime + math.random( 2 ) * 3
    local x1 = math.floor( half + ( half -  2 ) * math.sin(  currentTime /  47 ) )
    local x2 = math.floor( half + ( half /  7 ) * math.sin( -currentTime / 149 ) )
    local x3 = math.floor( half + ( half -  3 ) * math.sin( -currentTime / 157 ) )
    local y1 = math.floor( half + ( half / 11 ) * math.cos(  currentTime /  71 ) )
    local y2 = math.floor( half + ( half -  5 ) * math.cos( -currentTime / 181 ) )
    local y3 = math.floor( half + ( half / 23 ) * math.cos( -currentTime / 137 ) )
    s1 = y1 * doub + x1; s2 = y2 * doub + x2; s3 = y3 * doub + x3
    for j = 0, size do
        for i = 0, size do
            a = p2[s1] + p1[s2] + p2[s3]
            c1 = a * 2; c2 = a * 4; c3 = a * 8
            table.insert( points, { i, j, c1, c2, c3, 255 } )
            s1 = s1 + 1; s2 = s2 + 1; s3 = s3 + 1;
        end
        s1 = s1 + size; s2 = s2 + size; s3 = s3 + size
    end
    _.points( points )
end
