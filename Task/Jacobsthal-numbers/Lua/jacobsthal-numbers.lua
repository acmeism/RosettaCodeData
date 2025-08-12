do  -- find some Jacobsthal and related Numbers

    local maxJacobsthal <const>        -- highest Jacobsthal number we will find
        , maxOblong     <const>        -- highest Jacobsthal oblong number we will find
        , maxJPrime     <const>        -- number of Jacobsthal primes we will find
                = 29, 20, 10
    local j  <const>                    -- will hold Jacobsthal numbers
        , jl <const>                    -- will hold Jacobsthal-Lucas numbers
        , jo <const>                    -- will hold Jacobsthal oblong numbers
                = {}, {}, {}
    -- calculate the Jacobsthal Numbers and related numbers
    -- Jacobsthal      : J0  == 0, J1  == 1, Jn  == Jn-1  + 2 × Jn-2
    -- Jacobsthal-Lucas: JL0 == 2, JL1 == 1, JLn == JLn-1 + 2 × JLn-2
    -- Jacobsthal oblong: JOn == Jn x Jn-1
    -- Lua arrays can be indexed from 0 but as jo is indexed from 1, we index j, jl and jo
    -- from 1 to simplify printing them
    j[ 1 ], j[ 2 ], jl[ 1 ], jl[ 2 ], jo[ 1 ] = 0, 1, 2, 1, 0
    for n = 2, maxJacobsthal do
        j[  n + 1 ] = j[  n ] + ( 2 * j[  n - 1 ] )
        jl[ n + 1 ] = jl[ n ] + ( 2 * jl[ n - 1 ] )
    end
    for n = 1, maxOblong do
        jo[ n ] = j[ n + 1 ] * j[ n ]
    end

    function isPrime( p )
        if p <= 1 or p % 2 == 0 then
            return p == 2
        else
            local prime = true
            local i     = 3
            local rootP = math.floor( math.sqrt( p ) )
            while i <= rootP and prime do
                prime = p % i ~= 0
                i     = i + 1
            end
            return prime
        end
    end

    local function showNumbers( legend, numbers )
        io.write( string.format( "First %d %s\n", # numbers, legend ) )
        for n = 1, # numbers do
            io.write( string.format( " %11d", numbers[ n ] ) )
            if n % 5 == 0 then io.write( "\n" ) end
        end
    end

    -- show the various numbers numbers
    showNumbers( "Jacobsthal Numbers:",        j  )
    showNumbers( "Jacobsthal-Lucas Numbers:",  jl )
    showNumbers( "Jacobsthal oblong Numbers:", jo )
    -- find some prime Jacobsthal numbers
    io.write( string.format( "First %d Jacobstal primes:\n   n  Jn\n", maxJPrime ) )
    local jn1, jn2, pCount, n = j[ 2 ], j[ 1 ], 0, 2
    while pCount < maxJPrime do
        local jn <const> = jn1 + ( 2 * jn2 )
        jn2, jn1 = jn1, jn
        if isPrime( jn ) then
            pCount = pCount + 1
            io.write( string.format( "%4d: %d\n", n, jn ) )
        end
        n = n + 1
    end
end
