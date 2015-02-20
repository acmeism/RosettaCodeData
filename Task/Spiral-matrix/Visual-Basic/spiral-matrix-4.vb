Module modSpiralArray
    Sub Main()
        print2dArray(getSpiralArray(5))
    End Sub

    Function getSpiralArray(dimension As Integer) As Object
        Dim spiralArray(,) As Integer
        Dim numConcentricSquares As Integer

        ReDim spiralArray(dimension - 1, dimension - 1)
        numConcentricSquares = dimension \ 2
        If (dimension Mod 2) Then numConcentricSquares = numConcentricSquares + 1

        Dim j As Integer, sideLen As Integer, currNum As Integer
        sideLen = dimension

        Dim i As Integer
        For i = 0 To numConcentricSquares - 1
            ' do top side
            For j = 0 To sideLen - 1
                spiralArray(i, i + j) = currNum
                currNum = currNum + 1
            Next
            ' do right side
            For j = 1 To sideLen - 1
                spiralArray(i + j, dimension - 1 - i) = currNum
                currNum = currNum + 1
            Next
            ' do bottom side
            For j = sideLen - 2 To 0 Step -1
                spiralArray(dimension - 1 - i, i + j) = currNum
                currNum = currNum + 1
            Next
            ' do left side
            For j = sideLen - 2 To 1 Step -1
                spiralArray(i + j, i) = currNum
                currNum = currNum + 1
            Next
            sideLen = sideLen - 2
        Next
        getSpiralArray = spiralArray
    End Function

    Sub print2dArray(arr)
        Dim row As Integer, col As Integer, s As String
        For row = 0 To UBound(arr, 1)
            s = ""
            For col = 0 To UBound(arr, 2)
                s = s & " " & Right("  " & arr(row, col), 3)
            Next
            Debug.Print(s)
        Next
    End Sub

End Module
