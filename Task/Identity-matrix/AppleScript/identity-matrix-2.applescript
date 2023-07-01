on indentityMatrix(n)
    set digits to {}
    set m to n - 1
    repeat (n + m) times
        set end of digits to 0
    end repeat
    set item n of digits to 1

    set matrix to {}
    repeat with i from n to 1 by -1
        set end of matrix to items i thru (i + m) of digits
    end repeat

    return matrix
end indentityMatrix

return indentityMatrix(5)
