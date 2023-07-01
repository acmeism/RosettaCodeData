math.randomseed( os.time() )
local black, white, none, code = "X", "O", "-"
local colors, codeLen, maxGuess, rept, alpha, opt = 6, 4, 10, false, "ABCDEFGHIJKLMNOPQRST", ""
local guesses, results
function createCode()
    code = ""
    local dic, a = ""
    for i = 1, colors do
        dic = dic .. alpha:sub( i, i )
    end
    for i = 1, codeLen do
        a = math.floor( math.random( 1, #dic ) )
        code = code .. dic:sub( a, a )
        if not rept then
            dic = dic:sub(1, a - 1 ) .. dic:sub( a + 1, #dic )
        end
    end
end
function checkInput( inp )
    table.insert( guesses, inp )
    local b, w, fnd, str = 0, 0, {}, ""
    for bl = 1, codeLen do
        if inp:sub( bl, bl ) == code:sub( bl, bl ) then
            b = b + 1; fnd[bl] = true
        else
            for wh = 1, codeLen do
                if nil == fnd[bl] and wh ~= bl and inp:sub( wh, wh ) == code:sub( bl, bl ) then
                    w = w + 1; fnd[bl] = true
                end
            end
        end
    end
    for i = 1, b do str = str .. string.format( "%s ", black ) end
    for i = 1, w do str = str .. string.format( "%s ", white ) end
    for i = 1, 2 * codeLen - #str, 2 do str = str .. string.format( "%s ", none ) end
    table.insert( results, str )
    return b == codeLen
end
function play()
    local err, win, r = true, false;
    for j = 1, colors do opt = opt .. alpha:sub( j, j ) end
    while( true ) do
        createCode(); guesses, results = {}, {}
        for i = 1, maxGuess do
            err = true;
            while( err ) do
                io.write( string.format( "\n-------------------------------\nYour guess (%s)?", opt ) )
                inp = io.read():upper();
                if #inp == codeLen then
                    err = false;
                    for k = 1, #inp do
                        if( nil == opt:find( inp:sub( k, k ) ) ) then
                            err = true;
                            break;
                        end
                    end
                end
            end
            if( checkInput( inp ) ) then win = true; break
            else
                for l = 1, #guesses do
                    print( string.format( "%.2d: %s : %s", l, guesses[l], results[l] ) )
                end
            end
        end
        if win then print( "\nWell done!" )
        else print( string.format( "\nSorry, you did not crack the code --> %s!", code ) )
        end
        io.write( "Play again( Y/N )? " ); r = io.read()
        if r ~= "Y" and r ~= "y" then break end
    end
end
--[[ entry point ]]---
if arg[1] ~= nil and tonumber( arg[1] ) > 1 and tonumber( arg[1] ) < 21 then colors = tonumber( arg[1] ) end
if arg[2] ~= nil and tonumber( arg[2] ) > 3 and tonumber( arg[2] ) < 11 then codeLen = tonumber( arg[2] ) end
if arg[3] ~= nil and tonumber( arg[3] ) > 6 and tonumber( arg[3] ) < 21 then maxGuess = tonumber( arg[3] ) end
if arg[4] ~= nil and arg[4] == "true" or arg[4] == "false" then rept = ( arg[4] == "true" ) end
play()
