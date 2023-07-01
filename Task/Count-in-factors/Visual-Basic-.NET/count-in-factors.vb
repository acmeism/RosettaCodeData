Module CountingInFactors

    Sub Main()
        For i As Integer = 1 To 10
            Console.WriteLine("{0} = {1}", i, CountingInFactors(i))
        Next

        For i As Integer = 9991 To 10000
            Console.WriteLine("{0} = {1}", i, CountingInFactors(i))
        Next
    End Sub

    Private Function CountingInFactors(ByVal n As Integer) As String
        If n = 1 Then Return "1"

        Dim sb As New Text.StringBuilder()

        CheckFactor(2, n, sb)
        If n = 1 Then Return sb.ToString()

        CheckFactor(3, n, sb)
        If n = 1 Then Return sb.ToString()

        For i As Integer = 5 To n Step 2
            If i Mod 3 = 0 Then Continue For

            CheckFactor(i, n, sb)
            If n = 1 Then Exit For
        Next

        Return sb.ToString()
    End Function

    Private Sub CheckFactor(ByVal mult As Integer, ByRef n As Integer, ByRef sb As Text.StringBuilder)
        Do While n Mod mult = 0
            If sb.Length > 0 Then sb.Append(" x ")
            sb.Append(mult)
            n = n / mult
        Loop
    End Sub

End Module
