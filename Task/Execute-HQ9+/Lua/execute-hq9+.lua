function runCode( code )
    local acc, lc = 0
    for i = 1, #code do
        lc = code:sub( i, i ):upper()
        if lc == "Q" then print( lc )
        elseif lc == "H" then print( "Hello, World!" )
        elseif lc == "+" then acc = acc + 1
        elseif lc == "9" then
            for j = 99, 1, -1 do
                if j > 1 then
                    print( string.format( "%d bottles of beer on the wall\n%d bottles of beer\nTake one down, pass it around\n%d bottles of beer on the wall\n", j, j, j - 1 ) )
                else
                    print( "1 bottle of beer on the wall\n1 bottle of beer\nTake one down and pass it around\nno more bottles of beer on the wall\n\n"..
                           "No more bottles of beer on the wall\nNo more bottles of beer\n"..
                           "Go to the store and buy some more\n99 bottles of beer on the wall.\n" )
                end
            end
        end
    end
end
