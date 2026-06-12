do  -- SEND + MORE = MONEY puzzle
    local contains = function( t, v )
        for i = 1, # t do
            if t[ i ] == v then return true end
        end
        return false
    end
    local m <const> = 1
    for s = 8, 9 do
        for e = 0, 9 do
            if not contains( { m, s }, e ) then
                for n = 0, 9 do
                    if not contains( { m, s, e }, n ) then
                        for d = 0, 9 do
                            if not contains( { m, s, e, n }, d ) then
                                for o = 0, 9 do
                                    if not contains( { m, s, e, n, d }, o ) then
                                        for r = 0, 9 do
                                            if not contains( { m, s, e, n, d, o }, r ) then
                                                for y = 0, 9 do
                                                    if not contains( { m, s, e, n, d, o, r }, y ) then
                                                        if ( 1000 * s + 100 * e + 10 * n + d )
                                                         + ( 1000 * m + 100 * o + 10 * r + e )
                                                        == ( 10000 * m + 1000 * o + 100 * n + 10 * e + y )
                                                        then
                                                            print( s..e..n..d.." + "
                                                                 ..m..o..r..e.." = "
                                                                 ..m..o..n..e..y
                                                                 )
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end
