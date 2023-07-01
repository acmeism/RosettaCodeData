Module Module1

    Function sameDigits(ByVal n As Integer, ByVal b As Integer) As Boolean
        Dim f As Integer = n Mod b : n \= b : While n > 0
            If n Mod b <> f Then Return False Else n \= b
        End While : Return True
    End Function

    Function isBrazilian(ByVal n As Integer) As Boolean
        If n < 7 Then Return False
        If n Mod 2 = 0 Then Return True
        For b As Integer = 2 To n - 2
            If sameDigits(n, b) Then Return True
        Next : Return False
    End Function

    Function isPrime(ByVal n As Integer) As Boolean
        If n < 2 Then Return False
        If n Mod 2 = 0 Then Return n = 2
        If n Mod 3 = 0 Then Return n = 3
        Dim d As Integer = 5
        While d * d <= n
            If n Mod d = 0 Then Return False Else d += 2
            If n Mod d = 0 Then Return False Else d += 4
        End While : Return True
    End Function

    Sub Main(args As String())
        For Each kind As String In {" ", " odd ", " prime "}
            Console.WriteLine("First 20{0}Brazilian numbers:", kind)
            Dim Limit As Integer = 20, n As Integer = 7
            Do
                If isBrazilian(n) Then Console.Write("{0} ", n) : Limit -= 1
                Select Case kind
                    Case " " : n += 1
                    Case " odd " : n += 2
                    Case " prime " : Do : n += 2 : Loop Until isPrime(n)
                End Select
            Loop While Limit > 0
            Console.Write(vbLf & vbLf)
        Next
    End Sub

End Module
