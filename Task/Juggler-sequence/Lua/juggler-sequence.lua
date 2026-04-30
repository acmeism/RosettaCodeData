do  -- Jugglar sequences - starting with a[0] = n, a[k+1] = floor(sqrt(a[k])) if a[k] is even
    --                                                    = floor(sqrt(a[k]))*a[k] otherwise

    -- find the number of terms required to reach a[n] = 1, the maximum value of the sequence
    -- before it reaches 1 and the index at which the maximum was first reached

    print( " n  l[n]            h[n] i[n]" )
    print( "=============================" )
    for a0 = 20, 39 do
        local ak, amax, aindex, mindex = a0, 0, 0, 0
        while ak ~= 1 do
            if amax < ak then
                amax, mindex = ak, aindex
            end
            aindex = aindex + 1
            local rootAk <const> = math.sqrt( ak )
            ak = math.floor( ak % 2 == 1 and rootAk * ak or rootAk )
        end
        print( string.format( "%2d%5d%16d%5d", a0, aindex, amax, mindex ) )
    end

end
