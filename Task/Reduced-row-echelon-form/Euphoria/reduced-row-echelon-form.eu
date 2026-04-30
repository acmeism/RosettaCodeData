function ToReducedRowEchelonForm(sequence M)
    integer lead,rowCount,columnCount,i
    sequence temp
    lead = 1
    rowCount = length(M)
    columnCount = length(M[1])
    for r = 1 to rowCount do
        if columnCount <= lead then
            exit
        end if
        i = r
        while M[i][lead] = 0 do
            i += 1
            if rowCount = i then
                i = r
                lead += 1
                if columnCount = lead then
                    exit
                end if
            end if
        end while
        temp = M[i]
        M[i] = M[r]
        M[r] = temp
        M[r] /= M[r][lead]
        for j = 1 to rowCount do
            if j != r then
                M[j] -= M[j][lead]*M[r]
            end if
        end for
        lead += 1
    end for
    return M
end function

? ToReducedRowEchelonForm(
    { { 1, 2, -1, -4 },
      { 2, 3, -1, -11 },
      { -2, 0, -3, 22 } })
