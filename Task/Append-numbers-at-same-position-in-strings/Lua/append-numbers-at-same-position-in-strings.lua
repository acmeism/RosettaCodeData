do -- form a list of strings by concatenating numbers from 3 lists
    local list1, list2, list3 = {  1,  2,  3,  4,  5,  6,  7,  8,  9 }
                              , { 10, 11, 12, 13, 14, 15, 16, 17, 18 }
                              , { 19, 20, 21, 22, 23, 24, 25, 26, 27 }
    local result = {}
    for i = 1, #list1 do
        result[ i ] = list1[ i ]..list2[ i ]..list3[ i ]
    end
    print( "[ "..table.concat( result, " " ).." ]" )
end
