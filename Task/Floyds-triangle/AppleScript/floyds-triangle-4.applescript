on FloydsTriangle(n)
    set triangle to {}
    set i to 0
    repeat with w from 1 to n
        set row to {}
        repeat with i from (i + 1) to (i + w)
            set end of row to i
        end repeat
        set end of triangle to row
    end repeat

    return triangle
end FloydsTriangle

-- Task code:
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

local triangle5, text5, triangle14, text14
set triangle5 to FloydsTriangle(5)
set text5 to matrixToText(triangle5, (count (end of end of triangle5 as text)) + 1)
set triangle14 to FloydsTriangle(14)
set text14 to matrixToText(triangle14, (count (end of end of triangle14 as text)) + 1)
return linefeed & text5 & (linefeed & linefeed & text14 & linefeed)
