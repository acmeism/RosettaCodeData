on loopDemo(array, stopVal)
    set out to {}
    repeat with i from 1 to (count array)
        set inRow to item i of array
        set len to (count inRow)
        set n to beginning of inRow
        set outRow to {n}
        set j to 2
        repeat until ((j > len) or (n = stopVal)) # <--
            set n to item j of inRow
            set end of outRow to n
            set j to j + 1
        end repeat
        set end of out to outRow
        if (n = stopVal) then exit repeat # <--
    end repeat

    return out
end loopDemo
