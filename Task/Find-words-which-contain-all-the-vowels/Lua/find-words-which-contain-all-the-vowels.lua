do  -- find 11+ character words that contain 1 of each vowel

    for word in io.lines( "unixdict.txt" ) do
        if # word > 10 then
            local count <const> = { ["a"] = 0, ["e"] = 0, ["i"] = 0, ["o"] = 0, ["u"] = 0 }
            local single = true
            for c = 1, # word do
                local ch <const> = word:sub( c, c )
                if count[ ch ] ~= nil then
                    count[ ch ] = count[ ch ] + 1
                    single = count[ ch ] == 1
                    if not single then break end
                end
            end
            if single and ( count.a + count.e + count.i + count.o + count.u ) == 5 then
                print( word )
            end
        end
    end

end
