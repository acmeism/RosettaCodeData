Module Task1
    Iterator Function SequenceSingle() As IEnumerable(Of Single)
        ' n, n-1, and n-2
        Dim vn, vn_1, vn_2 As Single
        vn_2 = 2
        vn_1 = -4

        Do
            Yield vn_2
            vn = 111 - (1130 / vn_1) + (3000 / (vn_1 * vn_2))
            vn_2 = vn_1
            vn_1 = vn
        Loop
    End Function

    Iterator Function SequenceDouble() As IEnumerable(Of Double)
        ' n, n-1, and n-2
        Dim vn, vn_1, vn_2 As Double
        vn_2 = 2
        vn_1 = -4

        Do
            Yield vn_2
            vn = 111 - (1130 / vn_1) + (3000 / (vn_1 * vn_2))
            vn_2 = vn_1
            vn_1 = vn
        Loop
    End Function

    Iterator Function SequenceDecimal() As IEnumerable(Of Decimal)
        ' n, n-1, and n-2
        Dim vn, vn_1, vn_2 As Decimal
        vn_2 = 2
        vn_1 = -4

        ' Use constants to avoid calling the Decimal constructor in the loop.
        Const i11 As Decimal = 111
        Const i130 As Decimal = 1130
        Const E000 As Decimal = 3000

        Do
            Yield vn_2
            vn = i11 - (i130 / vn_1) + (E000 / (vn_1 * vn_2))
            vn_2 = vn_1
            vn_1 = vn
        Loop
    End Function

#If USE_BIGRATIONAL Then
    Iterator Function SequenceRational() As IEnumerable(Of BigRational)
        ' n, n-1, and n-2
        Dim vn, vn_1, vn_2 As BigRational
        vn_2 = 2
        vn_1 = -4

        ' Same reasoning as for Decimal.
        Dim i11 As BigRational = 111
        Dim i130 As BigRational = 1130
        Dim E000 As BigRational = 3000

        Do
            Yield vn_2
            vn = i11 - (i130 / vn_1) + (E000 / (vn_1 * vn_2))
            vn_2 = vn_1
            vn_1 = vn
        Loop
    End Function
#Else
    Iterator Function SequenceRational() As IEnumerable(Of BigRational)
        Do
            Yield Nothing
        Loop
    End Function
#End If

    <Conditional("INCREASED_LIMITS")>
    Sub IncreaseMaxN(ByRef arr As Integer())
        ReDim Preserve arr(arr.Length)
        arr(arr.Length - 1) = 1000
    End Sub

    Sub WrongConvergence()
        Console.WriteLine("Wrong Convergence Sequence:")

        Dim displayedIndices As Integer() = {3, 4, 5, 6, 7, 8, 20, 30, 50, 100}
        IncreaseMaxN(displayedIndices)

        Dim indicesSet As New HashSet(Of Integer)(displayedIndices)

        Console.WriteLine(Headings)

        Dim n As Integer = 1
        ' Enumerate the implementations in parallel as tuples.
        For Each x In SequenceSingle().
                      Zip(SequenceDouble(), Function(sn, db) (sn, db)).
                      Zip(SequenceDecimal(), Function(a, dm) (a.sn, a.db, dm)).
                      Zip(SequenceRational(), Function(a, br) (a.sn, a.db, a.dm, br))
            If n > displayedIndices.Max() Then Exit For

            If indicesSet.Contains(n) Then
                Console.WriteLine(FormatOutput(n, x))
            End If

            n += 1
        Next
    End Sub
End Module
