on loopDemo(array, stopVal)
    set out to {}
    repeat with i from 1 to (count array)
        set inRow to item i of array
        set outRow to {}
        repeat with j from 1 to (count inRow)
            set n to item j of inRow
            set end of outRow to n
            if (n = stopVal) then return out & {outRow} # <--
        end repeat
        set end of out to outRow
    end repeat

    return out
end loopDemo
