function prod( a, b )
    print( "\nPRODUCT:" )
    for m = 1, #a do
        for p = 1, #b do
            for n = 1, #a[m] do
                for q = 1, #b[p] do
                    io.write( string.format( "%3d ", a[m][n] * b[p][q] ) )
                end
            end
            print()
        end
    end
end
--[[entry point]]--
a = { { 1, 2 }, { 3, 4 } }; b = { { 0, 5 }, { 6, 7 } }
prod( a, b )
a = { { 0, 1, 0 }, { 1, 1, 1 }, { 0, 1, 0 } }
b = { { 1, 1, 1, 1 }, { 1, 0, 0, 1 }, { 1, 1, 1, 1 } }
prod( a, b )
