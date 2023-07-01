Sub CramersRule()
    OrigM = [{2,  -1, 5, 1; 3,2,2,-6;1,3,3,-1;5,-2,-3,3}]
    OrigD = [{-3;-32;-47;49}]

    MatrixSize = UBound(OrigM)
    DetOrigM = WorksheetFunction.MDeterm(OrigM)

    For i = 1 To MatrixSize
        ChangeM = OrigM

        For j = 1 To MatrixSize
            ChangeM(j, i) = OrigD(j, 1)
        Next j

        DetChangeM = WorksheetFunction.MDeterm(ChangeM)
        Debug.Print i & ": " & DetChangeM / DetOrigM
    Next i
End Sub
