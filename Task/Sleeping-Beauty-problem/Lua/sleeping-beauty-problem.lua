do  -- sleeping beauty problem - translated from the Wren sample, via Pluto

    local function sleepingBeauty( reps )
        local wakings, heads = 0, 0
        for _ = 1, reps do
            wakings = wakings + 1
            if math.random() < 0.5 then
                heads   = heads   + 1 -- [0..0.5) = heads
            else
                wakings = wakings + 1 -- [0.5..1.0) = tails
            end
        end
        print( "Wakings over " .. reps .. " repetitions = " .. wakings )
        return ( heads / wakings ) * 100
    end

    print( "Percentage probability of heads on waking = " .. sleepingBeauty( 1000000 ) )
end
