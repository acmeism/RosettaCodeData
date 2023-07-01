target, board, moves, W, H = {}, {}, 0, 3, 3

function getIndex( i, j ) return i + j * W - W end

function flip( d, r )
    function invert( a ) if a == 1 then return 0 end return 1 end
    local idx
    if d == 1 then
        for i = 1, W do
            idx = getIndex( i, r )
            board[idx] = invert( board[idx] )
        end
    else
        for i = 1, H do
            idx = getIndex( r, i )
            board[idx] = invert( board[idx] )
        end
    end
    moves = moves + 1
end
function createTarget()
    target, board = {}, {}
    local idx
    for j = 1, H do
        for i = 1, W do
            idx = getIndex( i, j )
            if math.random() < .5 then target[idx] = 0
            else target[idx] = 1
            end
            board[idx] = target[idx]
        end
    end
    for i = 1, 103 do
        if math.random() < .5 then flip( 1, math.random( H ) )
        else flip( 2, math.random( W ) )
        end
    end
    moves = 0
end
function getUserInput()
    io.write( "Input row and/or column: " ); local r = io.read()
    local a
    for i = 1, #r do
        a = string.byte( r:sub( i, i ):lower() )
        if a >= 48 and a <= 57 then flip( 2, a - 48 ) end
        if a >= 97 and a <= string.byte( 'z' ) then flip( 1, a - 96 ) end
    end
end
function solved()
    local idx
    for j = 1, H do
        for i = 1, W do
            idx = getIndex( i, j )
            if target[idx] ~= board[idx] then return false end
        end
    end
    return true
end
function display()
    local idx
    io.write( "\nTARGET\n   " )
    for i = 1, W do io.write( string.format( "%d  ", i ) ) end; print()
    for j = 1, H do
        io.write( string.format( "%s  ", string.char( 96 + j ) ) )
        for i = 1, W do
            idx = getIndex( i, j )
            io.write( string.format( "%d  ", target[idx] ) )
        end; io.write( "\n" )
    end
    io.write( "\nBOARD\n   " )
    for i = 1, W do io.write( string.format( "%d  ", i ) ) end; print()
    for j = 1, H do
        io.write( string.format( "%s  ", string.char( 96 + j ) ) )
        for i = 1, W do
            idx = getIndex( i, j )
            io.write( string.format( "%d  ", board[idx] ) )
        end; io.write( "\n" )
    end
    io.write( string.format( "Moves: %d\n", moves ) )
end
function play()
    while true do
        createTarget()
        repeat
            display()
            getUserInput()
        until solved()
        display()
        io.write( "Very well!\nPlay again(Y/N)? " );
        if io.read():lower() ~= "y" then return end
    end
end
--[[entry point]]--
math.randomseed( os.time() )
play()
