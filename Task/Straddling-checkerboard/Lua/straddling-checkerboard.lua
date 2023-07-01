local brd = { "HOL MES RT", "ABCDFGIJKN", "PQUVWXYZ./" }
local dicE, dicD, s1, s2 = {}, {}, 0, 0

function dec( txt )
    local i, numb, s, t, c = 1, false
    while( i < #txt ) do
        c = txt:sub( i, i )
        if not numb then
            if tonumber( c ) == s1 then
                i = i + 1; s = string.format( "%d%s", s1, txt:sub( i, i ) )
                t = dicD[s]
            elseif tonumber( c ) == s2 then
                i = i + 1; s = string.format( "%d%s", s2, txt:sub( i, i ) )
                t = dicD[s]
            else
                t = dicD[c]
            end
            if t == "/" then
                numb = true
            else
                io.write( t )
            end
        else
            io.write( c )
            numb = false
        end
        i = i + 1
    end
    print()
end
function enc( txt )
    local c
    for i = 1, #txt do
        c = txt:sub( i, i )
        if c >= "A" and c <= "Z" then
            io.write( dicE[c] )
        elseif c >= "0" and c <= "9" then
            io.write( string.format( "%s%s", dicE["/"], c ) )
        end
    end
    print()
end
function createDictionaries()
    for i = 1, 10 do
        c = brd[1]:sub( i, i )
        if c == " " then
            if s1 == 0 then s1 = i - 1
            elseif s2 == 0 then s2 = i - 1 end
        else
            dicE[c] = string.format( "%d", i - 1 )
            dicD[string.format( "%d", i - 1 )] = c
        end
    end
    for i = 1, 10 do
        dicE[brd[2]:sub( i, i )] = string.format( "%d%d", s1, i - 1 )
        dicE[brd[3]:sub( i, i )] = string.format( "%d%d", s2, i - 1 )
        dicD[string.format( "%d%d", s1, i - 1 )] = brd[2]:sub( i, i )
        dicD[string.format( "%d%d", s2, i - 1 )] = brd[3]:sub( i, i )
    end
end
function enterText()
    createDictionaries()
    io.write( "\nEncrypt or Decrypt (E/D)? " )
    d = io.read()
    io.write( "\nEnter the text:\n" )
    txt = io.read():upper()
    if d == "E" or d == "e" then enc( txt )
    elseif d == "D" or d == "d" then dec( txt )
    end
end
-- entry point
enterText()
