Module Module1

    Function IsCUSIP(s As String) As Boolean
        If s.Length <> 9 Then
            Return False
        End If

        Dim sum = 0
        For i = 0 To 7
            Dim c = s(i)

            Dim v As Integer
            If "0" <= c AndAlso c <= "9" Then
                v = Asc(c) - 48
            ElseIf "A" <= c AndAlso c <= "Z" Then
                v = Asc(c) - 55 ' Lower case letters are apparently invalid
            ElseIf c = "*" Then
                v = 36
            ElseIf c = "#" Then
                v = 38
            Else
                Return False
            End If

            If i Mod 2 = 1 Then
                v *= 2 ' check if odd as using 0-based indexing
            End If
            sum += v \ 10 + v Mod 10
        Next
        Return Asc(s(8)) - 48 = (10 - (sum Mod 10)) Mod 10
    End Function

    Sub Main()
        Dim candidates As New List(Of String) From {
            "037833100",
            "17275R102",
            "38259P508",
            "594918104",
            "68389X106",
            "68389X105"
        }

        For Each candidate In candidates
            Console.WriteLine("{0} -> {1}", candidate, If(IsCUSIP(candidate), "correct", "incorrect"))
        Next
    End Sub

End Module
