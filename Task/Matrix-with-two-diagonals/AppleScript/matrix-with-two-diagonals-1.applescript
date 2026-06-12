on twoDiagonalMatrix(n)
    if (n < 2) then error "twoDiagonalMatrix() handler: parameter must be > 1."

    set digits to {}
    set oddness to n mod 2
    repeat (n - 1 + oddness) times
        set end of digits to 0
    end repeat
    set m to n div 2 + oddness -- Middle index of digit source list.
    set item m of digits to 1

    set matrix to {}
    set leftLen to m - 1 -- Length of left end of each row - 1.
    set rightLen to leftLen - oddness -- Length of right end ditto.
    -- Assemble the first m rows from the relevant sections of 'digits'.
    repeat with i from m to 1 by -1
        set end of matrix to items i thru (i + leftLen) of digits & items -(i + rightLen) thru -i of digits
    end repeat

    -- The remaining rows are the reverse of these, not repeating the mth where n is odd.
    return matrix & reverse of items 1 thru (m - oddness) of matrix
end twoDiagonalMatrix

-- Task code.
on matrixToText(matrix, separator)
    copy matrix to matrix
    set astid to AppleScript's text item delimiters
    set AppleScript's text item delimiters to separator
    repeat with thisLine in matrix
        set thisLine's contents to thisLine as text
    end repeat
    set AppleScript's text item delimiters to linefeed
    set matrix to matrix as text
    set AppleScript's text item delimiters to astid
    return matrix
end matrixToText

return linefeed & matrixToText(twoDiagonalMatrix(7), space) & ¬
    (linefeed & linefeed & matrixToText(twoDiagonalMatrix(8), space))
