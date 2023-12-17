do -- Jacobi symbol - translation of the Algol 68 sample


    local function jacobi( aIn, nIn )
        if nIn <= 0 or nIn % 2 == 0 then
            print( "The 'n' parameter of jacobi must be an odd positive integer." )
            return 0
        else
            local a, n, result = aIn % nIn, nIn, 1
            while a ~= 0 do
                while a % 2 == 0 do
                    a = math.floor( a / 2 )
                    local nm8 = n % 8
                    if nm8 == 3 or nm8 == 5 then result = - result end
                end
                a, n = n, a;
                if a % 4 == 3 and n % 4 == 3 then result = - result end
                a = a % n
            end
            return n == 1 and result or 0
         end
    end

    print( "Table of jacobi(a, n):" );
    print( "n/a   1   2   3   4   5   6   7   8   9  10  11  12  13  14  15" )
    print( "---------------------------------------------------------------" )
    for n = 1, 29, 2 do
        io.write( string.format( "%3d", n ) )
        for a = 1, 15 do io.write( string.format( "%4d", jacobi( a, n ) ) ) end
        io.write( "\n" )
    end

end
