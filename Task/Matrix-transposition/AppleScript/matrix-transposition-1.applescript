on run
    transpose([[1, 2, 3], [4, 5, 6], [7, 8, 9], [10, 11, 12]])

    --> {{1, 4, 7, 10}, {2, 5, 8, 11}, {3, 6, 9, 12}}
end run

on transpose(xss)
    set lstTrans to {}

    repeat with iCol from 1 to length of item 1 of xss
        set lstCol to {}

        repeat with iRow from 1 to length of xss
            set end of lstCol to item iCol of item iRow of xss
        end repeat

        set end of lstTrans to lstCol
    end repeat

    return lstTrans
end transpose
