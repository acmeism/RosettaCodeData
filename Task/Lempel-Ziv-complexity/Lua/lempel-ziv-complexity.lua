do  -- Lempel-Ziv complexity

    -- returns the LZ complexity of str and the substrings, from the Wikipedia pseudocode
    --         except the complexity of "" is returned as 0
    local function lempel_ziv_complexity( S )
        local n <const>, subs <const> = # S, {}
        local i, C, u, v = 0, 0, 1, 1
        if n > 0 then
            local vmax = v
            C = 1
            subs[ C ] = S:sub( 1, 1 )
            while u + v <= n do
                if S:sub( i + v, i + v ) == S:sub( u + v, u + v ) then
                    v = v + 1
                else
                    vmax = math.max( v, vmax )
                    i = i + 1
                    if i == u then
                        C = C + 1
                        subs[ C ] = S:sub( u + 1, u + vmax )
                        u, i, vmax = u + vmax, 0, 1
                    end
                    v = 1
                end
            end
            if v ~= 1 then
                C = C + 1
                subs[ C ] = S:sub( u + 1, n )
            end
        end
        return C, table.concat( subs, "." )
    end

    do  -- task test cases
        local tests = { { "AZSEDRFTGYGUJIJOKB",         16 }
                      , { "ABCABCABCABCABCABC",          4 }
                      , { "111011111001111011111001",    6 }
                      , { "101001010010111110",          5 }
                      , { "1001111011000010",            6 }
                      , { "1010101010",                  3 }
                      , { "1010101010101010",            3 }
                      , { "1001111011000010000010",      7 }
                      , { "100111101100001000001010",    8 }
                      , { "0001101001000101",            6 }
                      , { "1111111",                     2 }
                      , { "0001",                        2 }
                      , { "010",                         3 }
                      , { "1",                           1 }
                      , { "",                            0 }
                      , { "01011010001101110010",        7 }
                      , { "ABCDEFGHIJKLMNOPQRSTUVWXYZ", 26 }
                      , { "HELLO WORLD! HELLO WORLD! HELLO WORLD! HELLO WORLD!"
                        , 11
                        }
                      }
        io.write( "                          String  LZ Substrings\n" )
        io.write( "================================ === " )
        io.write( "=================================================\n" )
        for _, test in ipairs( tests ) do
            local str <const>, expected <const> = test[ 1 ], test[ 2 ]
            local complexity <const>, subs <const> = lempel_ziv_complexity( str )
            if complexity ~= expected then
                print( string.format( "%s: got complexity %d, expected %d\n", str, complexity, expected ) )
            end
            if # str <= 32 then
                io.write( string.format( "%32s %3d %s", str, complexity, subs ) )
            else
                io.write( string.format( "%s\n%32s %3d %s", str, "->", complexity, subs ) )
            end
            io.write( "\n" )
        end
    end

end
