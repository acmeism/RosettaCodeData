do  -- test lists contain exactly 3 threes and that they are adjacent

    local lists <const> = { { 9, 3, 3, 3, 2, 1, 7, 8, 5 } -- task test case
                          , { 5, 2, 9, 3, 3, 7, 8, 4, 1 } --   "    "    "
                          , { 1, 4, 3, 6, 7, 3, 8, 3, 2 } --   "    "    "
                          , { 1, 2, 3, 4, 5, 6, 7, 8, 9 } --   "    "    "
                          , { 4, 6, 8, 7, 2, 3, 3, 3, 1 } --   "    "    "
                          , { 3, 3, 3, 1, 2, 4, 5, 1, 3 } -- additional test from the Raku/Wren sample
                          , { 0, 3, 3, 3, 3, 7, 2, 2, 6 } -- additional test from the Raku/Wren sample
                          , { 3, 3, 3, 3, 3, 4, 4, 4, 4 } -- additional test from the Raku/Wren sample
                          }

    for lPos = 1, # lists do
        local list <const> = lists[ lPos ]
        local threes, threePos = 0, 0  -- number of threes in the list and position of the last
        local listOk = false
        for ePos = 1, # list do
            if list[ ePos ] == 3 then
                threes   = threes + 1
                threePos = ePos
            end
        end
        if threes == 3 then -- have exactly 3 threes - check they are adjacent
            listOk = list[ threePos - 1 ] == 3 and list[ threePos - 2 ] == 3
        end

        -- show the result
        io.write( "[ ", table.concat( list, " " ), " ] -> ", ( listOk and "true" or "false" ), "\n" )
    end
end
