-- Params:
-- List of lists (rows) of "pixel" values.
-- Record indicating the values representing black and white.
on ZhangSuen(matrix, {black:black, white:white})
    script o
        property matrix : missing value
        property changePixels : missing value

        on A(neighbours) -- Count transitions from white to black.
            set sum to 0
            repeat with i from 1 to 8
                if ((neighbours's item i is white) and (neighbours's item (i mod 8 + 1) is black)) then set sum to sum + 1
            end repeat
            return sum
        end A

        on B(neighbours) -- Count neighbouring black pixels.
            set sum to 0
            repeat with p in neighbours
                if (p's contents is black) then set sum to sum + 1
            end repeat
            return sum
        end B
    end script

    set o's matrix to matrix
    set rowCount to (count o's matrix)
    set columnCount to (count o's matrix's beginning) -- Assumed to be the same for every row.
    repeat until (o's changePixels is {})
        repeat with step from 1 to 2
            set o's changePixels to {}
            repeat with r from 2 to (rowCount - 1)
                repeat with c from 2 to (columnCount - 1)
                    if (o's matrix's item r's item c is black) then
                        tell (a reference to o's matrix) to ¬
                            set neighbours to {item (r - 1)'s item c, item (r - 1)'s item (c + 1), ¬
                                item r's item (c + 1), item (r + 1)'s item (c + 1), item (r + 1)'s item c, ¬
                                item (r + 1)'s item (c - 1), item r's item (c - 1), item (r - 1)'s item (c - 1)}
                        set blackCount to o's B(neighbours)
                        if ((blackCount > 1) and (blackCount < 7) and (o's A(neighbours) is 1)) then
                            set {P2, x, P4, x, P6, x, P8} to neighbours
                            if (step is 1) then
                                set toChange to ((P4 is white) or (P6 is white) or ((P2 is white) and (P8 is white)))
                            else
                                set toChange to ((P2 is white) or (P8 is white) or ((P4 is white) and (P6 is white)))
                            end if
                            if (toChange) then set end of o's changePixels to {r, c}
                        end if
                    end if
                end repeat
            end repeat
            if (o's changePixels is {}) then exit repeat
            repeat with pixel in o's changePixels
                set {r, c} to pixel
                set o's matrix's item r's item c to white
            end repeat
        end repeat
    end repeat

    return o's matrix -- or: return matrix -- The input has been edited in place.
end ZhangSuen

on join(lst, delim)
    set astid to AppleScript's text item delimiters
    set AppleScript's text item delimiters to delim
    set txt to lst as text
    set AppleScript's text item delimiters to astid
    return txt
end join

on demo()
    set pattern to "00000000000000000000000000000000
01111111110000000111111110000000
01110001111000001111001111000000
01110000111000001110000111000000
01110001111000001110000000000000
01111111110000001110000000000000
01110111100000001110000111000000
01110011110011101111001111011100
01110001111011100111111110011100
00000000000000000000000000000000"
    set matrix to pattern's paragraphs
    repeat with thisRow in matrix
        set thisRow's contents to thisRow's characters
    end repeat
    ZhangSuen(matrix, {black:"1", white:"0"})
    repeat with thisRow in matrix
        set thisRow's contents to join(thisRow, "")
    end repeat
    return join(matrix, linefeed)
end demo
return demo()
