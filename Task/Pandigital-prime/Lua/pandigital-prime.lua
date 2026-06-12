for sp = 0, 1 do
    local done = false
    for x = ( sp == 1 and 7654321 or 76543211 ), 0, -2 do
        if done then break end
        if x % 3 ~= 0 then
            local s <const> = tostring( x )
            done = true
            for ch = sp, 7 do
                done = nil ~= s:find( string.char( ch + string.byte( "0" ) ) )
                if not done then break end
            end
            local i = 1
            while i * i < x and done do
                i = i + 4
                if x % i == 0 then
                    done = false
                else
                    i = i + 2
                    done = x % i ~= 0
                end
            end
            if done then print( sp .. "..7: " .. x ) end
        end
    end
end
