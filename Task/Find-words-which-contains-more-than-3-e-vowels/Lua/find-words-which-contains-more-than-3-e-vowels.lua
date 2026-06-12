do  -- find words that contain more than 3 es

    local otherVowels = { ["a"] = true, ["i"] = true, ["o"] = true, ["u"] = true }

    for word in io.lines( "unixdict.txt" ) do
        local es, others = 0, false
        for c = 1, # word do
            local ch <const> = word:sub( c, c )
            if ch == "e" then
                es = es + 1
            elseif otherVowels[ ch ] then
                others = true
                break
            end
        end
        if es > 3 and not others then
            print( word )
        end
    end

end
