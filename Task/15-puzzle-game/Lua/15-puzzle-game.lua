math.randomseed( os.time() )
local puz = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 0 }
local dir = { { 1, 0 }, { -1, 0 }, { 0, 1 }, { 0, -1 } }
local sx, sy = 4, 4

function isValid( tx, ty )
    return tx > 0 and tx < 5 and ty > 0 and ty < 5
end
function display()
    io.write( "\n\n" )
    for j = 1, 4 do
        io.write( "+----+----+----+----+\n" )
        for i = 1, 4 do
            local d = puz[i + j * 4 - 4]
            io.write( ": " )
            if d < 10 then io.write( " " ) end
            if d < 1  then
                io.write( "  " )
            else
                io.write( string.format( "%d ", d ) )
            end
        end
        io.write( ":\n" )
    end
    io.write( "+----+----+----+----+\n\n" )
end
function getUserNove()
    local moves, r, tx, ty = {}
    for d = 1, 4 do
        tx = sx; ty = sy
        tx = tx + dir[d][1]; ty = ty + dir[d][2]

        if isValid( tx, ty ) then
            table.insert( moves, puz[tx + ty * 4 - 4] )
        end
    end

    io.write( "Your possible moves are: " )
    for i = 1, #moves do
        io.write( string.format( "%d ", moves[i] ) )
    end

    io.write ( "\nYour move: " ); r = tonumber( io.read() )
    if r ~= nil then
        for i = 1, #moves do
            if moves[i] == r then return r end
        end
    end
    print( "Invalid move!" )
    return -1
end
function checked( r )
    for i = 1, #puz do
        if puz[i] == r then
            puz[i] = 0
            sx = 1 + ( i - 1 ) % 4; sy = math.floor( ( i + 3 ) / 4 )
        elseif puz[i] == 0 then
            puz[i] = r
        end
    end
    for i = 2, #puz - 1 do
        if puz[i - 1] + 1 ~= puz[i] then return false end
    end
    return true
end
function beginGame()
    local r, d, tx, ty
    while( true ) do
        for i = 1, 100 do
            while( true ) do
                tx = sx; ty = sy; d = math.random( 4 )
                tx = tx + dir[d][1]; ty = ty + dir[d][2]
                if isValid( tx, ty ) then break end
            end
            puz[sx + sy * 4 - 4] = puz[tx + ty * 4 - 4]
            puz[tx + ty * 4 - 4] = 0; sx = tx; sy = ty
        end
        while( true ) do
            display(); r = getUserNove()
            if r > 0 then
                if checked( r ) then
                    display()
                    io.write( "\nDone!\n\nPlay again (Y/N)?" )
                    r = io.read()
                    if r ~= "Y" and r ~= "y" then
                        return
                    else
                        break
                    end
                end
            end
        end
    end
end
-- [ entry point ] --
beginGame()
