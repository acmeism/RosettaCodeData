Dim grid(9, 9)
Dim gridSolved(9, 9)

Public Sub Solve(i, j)
    If i > 9 Then
        'exit with gridSolved = Grid
        For r = 1 To 9
	    For c = 1 To 9
	        gridSolved(r, c) = grid(r, c)
	    Next 'c
        Next 'r
        Exit Sub
    End If
    For n = 1 To 9
        If isSafe(i, j, n) Then
          nTmp = grid(i, j)
          grid(i, j) = n
          If j = 9 Then
                Solve i + 1, 1
          Else
                Solve i, j + 1
          End If
          grid(i, j) = nTmp
        End If
    Next 'n
End Sub 'Solve

Public Function isSafe(i, j, n)
    If grid(i, j) <> 0 Then
        isSafe = (grid(i, j) = n)
        Exit Function
    End If
    'grid(i,j) is an empty cell. Check if n is OK
    'first check the row i
    For c = 1 To 9
        If grid(i, c) = n Then
            isSafe = False
            Exit Function
        End If
    Next 'c
    'now check the column j
    For r = 1 To 9
        If grid(r, j) = n Then
            isSafe = False
            Exit Function
        End If
    Next 'r
    'finally, check the 3x3 subsquare containing grid(i,j)
    iMin = 1 + 3 * Int((i - 1) / 3)
    jMin = 1 + 3 * Int((j - 1) / 3)
    For r = iMin To iMin + 2
        For c = jMin To jMin + 2
            If grid(r, c) = n Then
                isSafe = False
                Exit Function
            End If
        Next 'c
    Next 'r
    'all tests were OK
    isSafe = True
End Function 'isSafe

Public Sub Sudoku()
    'main routine
   Dim s(9)
    s(1) = "001005070"
    s(2) = "920600000"
    s(3) = "008000600"
    s(4) = "090020401"
    s(5) = "000000000"
    s(6) = "304080090"
    s(7) = "007000300"
    s(8) = "000007069"
    s(9) = "010800700"
    For i = 1 To 9
        For j = 1 To 9
            grid(i, j) = Int(Mid(s(i), j, 1))
        Next 'j
    Next 'j
    'print problem
    Wscript.echo "Problem:"
    For i = 1 To 9
	    c=""
        For j = 1 To 9
            c=c & grid(i, j) & " "
        Next 'j
	    Wscript.echo c
    Next 'i
    'solve it!
    Solve 1, 1
    'print solution
    Wscript.echo "Solution:"
    For i = 1 To 9
	    c=""
        For j = 1 To 9
            c=c & gridSolved(i, j) & " "
        Next 'j
	    Wscript.echo c
    Next 'i
End Sub 'Sudoku

Call sudoku
