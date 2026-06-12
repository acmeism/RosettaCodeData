do  -- Long Stairs - translation of Pluto

    local trials <const> = 10000
    local t_total, s_total = 0, 0

    print( "Seconds  steps behind  steps ahead" )

    for i = 1, trials do
        local stairs, location, seconds, more = 100, 0, 0, true
        while more do
            seconds, location = seconds + 1, location + 1
            if location > stairs then more = false
            else
                for _ = 1, 5 do
                    local roll <const> = math.floor( math.random() * stairs + 1 )
                    if roll <= location then location = location + 1 end
                    stairs = stairs + 1
                end
                if i == 1 and seconds >= 600 and seconds <= 609 then
                    print( string.format( "  %d        %d         %d", seconds, location, stairs - location ) )
                end
            end
        end
        t_total, s_total = t_total + seconds, s_total + stairs
    end

    io.write( string.format( "Average seconds %.4f", t_total / trials ) )
    io.write( string.format( ",  Average steps %.4f\n", s_total / trials ) )
end
