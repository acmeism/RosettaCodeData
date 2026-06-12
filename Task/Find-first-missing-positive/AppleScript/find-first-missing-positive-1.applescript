local output, aList, n
set output to {}
repeat with aList in {{1, 2, 0}, {3, 4, -1, 1}, {7, 8, 9, 11, 12}}
    set n to 1
    repeat while (aList contains n)
        set n to n + 1
    end repeat
    set end of output to n
end repeat
return output
