on zigzagMatrix(n)
    script o
        property matrix : {} -- Matrix list.
        property row : missing value -- Row sublist.
    end script

    repeat n times
        set end of o's matrix to {} -- Build a foundation for the matrix out of n empty lists.
    end repeat

    set {r, d} to {1, -1} -- Row index and direction to next insertion row (negative = row above).
    repeat with v from 0 to (n ^ 2) - 1 -- Values to insert.
        set o's row to o's matrix's item r
        repeat while ((count o's row) = n)
            set r to r + 1
            set d to 1
            set o's row to o's matrix's item r
        end repeat
        set end of o's row to v
        set r to r + d
        if (r < 1) then
            set r to 1
            set d to -d
        else if (r > n) then
            set r to n
            set d to -d
        else if ((r > 1) and ((count o's matrix's item (r - 1)) = 1)) then
            set d to -d
        end if
    end repeat

    return o's matrix
end zigzagMatrix

-- Demo:
on matrixToText(matrix, w)
    script o
        property matrix : missing value
        property row : missing value
    end script

    set o's matrix to matrix
    set padding to "          "
    repeat with r from 1 to (count o's matrix)
        set o's row to o's matrix's item r
        repeat with i from 1 to (count o's row)
            set o's row's item i to text -w thru end of (padding & o's row's item i)
        end repeat
        set o's matrix's item r to join(o's row, "")
    end repeat

    return join(o's matrix, linefeed)
end matrixToText

on join(lst, delim)
    set astid to AppleScript's text item delimiters
    set AppleScript's text item delimiters to delim
    set txt to lst as text
    set AppleScript's text item delimiters to astid
    return txt
end join

set n to 5
set matrix to zigzagMatrix(n)
linefeed & matrixToText(matrix, (count (n ^ 2 - 1 as integer as text)) + 2) & linefeed
