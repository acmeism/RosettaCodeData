local p1, p1W = ".xxx.....x.xx....xxxxxxxxxx..x.xx.x..xxxsxxxxxx...xx.x.....xxx..", 8
local p2, p2W = ".....s.x..........x.x.........xxxxx.........xxx.......x..x.x..x..xxxxx...xxxxx..xx.....xx..xxxxx...xxxxx..x..x.x..x.......xxx.........xxxxx.........x.x..........x.x.....", 13
local puzzle, movesCnt, wid = {}, 0, 0
local moves = { { -1, -2 }, {  1, -2 }, { -1,  2 }, {  1,  2 },
                { -2, -1 }, { -2,  1 }, {  2, -1 }, {  2,  1 } }

function isValid( x, y )
    return( x > 0 and x <= wid and y > 0 and y <= wid and puzzle[x + y * wid - wid] == 0 )
end
function solve( x, y, s )
    if s > movesCnt then return true end
    local test, a, b
    for i = 1, #moves do
        test = false
        a = x + moves[i][1]; b = y + moves[i][2]
        if isValid( a, b ) then
            puzzle[a + b * wid - wid] = s
            if solve( a, b, s + 1 ) then return true end
            puzzle[a + b * wid - wid] = 0
        end
    end
    return false
end
function printSolution()
    local lp
    for j = 1, wid do
        for i = 1, wid do
            lp = puzzle[i + j * wid - wid]
            if lp == -1 then io.write( "   " )
            else io.write( string.format( " %.2d", lp ) )
            end
        end
        print()
    end
    print( "\n" )
end
local sx, sy
function fill( pz, w )
    puzzle = {}; wid = w; movesCnt = #pz
    local lp
    for i = 1, #pz do
        lp = pz:sub( i, i )
        if lp == "x" then
            table.insert( puzzle, 0 )
        elseif lp == "." then
            table.insert( puzzle, -1 ); movesCnt = movesCnt - 1
        else
            table.insert( puzzle, 1 )
            sx = 1 + ( i - 1 ) % wid; sy = math.floor( ( i + wid - 1 ) / wid )
        end
    end
end
-- [[ entry point ]] --
print( "\n\n" ); fill( p1, p1W );
if solve( sx, sy, 2 ) then printSolution() end
print( "\n\n" ); fill( p2, p2W );
if solve( sx, sy, 2 ) then printSolution() end
