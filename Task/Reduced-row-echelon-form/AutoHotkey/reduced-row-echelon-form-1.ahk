ToReducedRowEchelonForm(M){
    rowCount 	:= M.Count()		; the number of rows in M
    columnCount := M.1.Count()		; the number of columns in M
    r := lead := 1
    while (r <= rowCount) {
        if (columnCount < lead)
            return M
        i := r
        while (M[i, lead] = 0) {
            i++
            if (rowCount+1 = i) {
                i := r, 	lead++
                if (columnCount+1 = lead)
                    return M
            }
        }
        if (i<>r)
            for col, v in M[i]		; Swap rows i and r
                tempVal := M[i, col],	M[i, col] := M[r, col],		M[r, col] := tempVal

        num := M[r, lead]
        if (M[r, lead] <> 0)
            for col, val in M[r]
                M[r, col] /= num	; If M[r, lead] is not 0 divide row r by M[r, lead]

        i := 2
        while (i <= rowCount) {
            num := M[i, lead]
            if (i <> r)
                for col, val in M[i]	; Subtract M[i, lead] multiplied by row r from row i
                    M[i, col] -= num * M[r, col]
            i++
        }
        lead++,		r++
    }
    return M
}
