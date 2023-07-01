Sub spiral()
    Dim n As Integer, a As Integer, b As Integer
    Dim numCsquares As Integer, sideLen As Integer, currNum As Integer
    Dim j As Integer, i As Integer
    Dim j1 As Integer, j2 As Integer, j3 As Integer

    n = 5

    Dim spiralArr(9, 9) As Integer
    numCsquares = CInt(Application.WorksheetFunction.Ceiling(n / 2, 1))
    sideLen = n
    currNum = 0
    For i = 0 To numCsquares - 1
        'do top side
        For j = 0 To sideLen - 1
            currNum = currNum + 1
            spiralArr(i, i + j) = currNum
        Next j

        'do right side
        For j1 = 1 To sideLen - 1
            currNum = currNum + 1
            spiralArr(i + j1, n - 1 - i) = currNum
        Next j1

        'do bottom side
        j2 = sideLen - 2
        Do While j2 > -1
            currNum = currNum + 1
            spiralArr(n - 1 - i, i + j2) = currNum
            j2 = j2 - 1
        Loop

        'do left side
        j3 = sideLen - 2
        Do While j3 > 0
            currNum = currNum + 1
            spiralArr(i + j3, i) = currNum
            j3 = j3 - 1
        Loop

        sideLen = sideLen - 2
    Next i

    For a = 0 To n - 1
        For b = 0 To n - 1
        Cells(a + 1, b + 1).Select
            ActiveCell.Value = spiralArr(a, b)
        Next b
    Next a
End Sub
