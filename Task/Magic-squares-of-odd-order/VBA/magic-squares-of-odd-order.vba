Sub magicsquare()
    'Magic squares of odd order
    Const n = 9
    Dim i As Integer, j As Integer, v As Integer
    Debug.Print "The square order is: " & n
    For i = 1 To n
        For j = 1 To n
            Cells(i, j) = ((i * 2 - j + n - 1) Mod n) * n + ((i * 2 + j - 2) Mod n) + 1
        Next j
    Next i
    Debug.Print "The magic number of"; n; "x"; n; "square is:"; n * (n * n + 1) \ 2
End Sub 'magicsquare
