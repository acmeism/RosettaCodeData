on task()
    set values to {}
    set squareCount to 0
    repeat with n from 1 to (1000000 - 1)
        set v to n + (0.5 + n ^ 0.5) div 1
        if (n ≤ 22) then set end of values to v
        set sqrt to v ^ 0.5
        if (sqrt = sqrt as integer) then set squareCount to squareCount + 1
    end repeat
    return "Values (n = 1 to 22): " & join(values, ", ") & (linefeed & ¬
        "Number of squares (n < 1000000): " & squareCount)
end task

on join(lst, delim)
    set astid to AppleScript's text item delimiters
    set AppleScript's text item delimiters to delim
    set txt to lst as text
    set AppleScript's text item delimiters to astid
    return txt
end join

task()
