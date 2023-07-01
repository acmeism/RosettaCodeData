    Function FiboBig(ByVal n As Integer) As BigInteger
        ' Fibonacci sequence with BigInteger
        Dim fibn2, fibn1, fibn As BigInteger
        Dim i As Integer
        fibn = 0
        fibn2 = 0
        fibn1 = 1
        If n = 0 Then
            Return fibn2
        ElseIf n = 1 Then
            Return fibn1
        ElseIf n >= 2 Then
            For i = 2 To n
                fibn = fibn2 + fibn1
                fibn2 = fibn1
                fibn1 = fibn
            Next i
            Return fibn
        End If
        Return 0
    End Function 'FiboBig

    Sub fibotest()
        Dim i As Integer, s As String
        i = 2000000  ' 2 millions
        s = FiboBig(i).ToString
        Console.WriteLine("fibo(" & i & ")=" & s & " - length=" & Len(s))
    End Sub 'fibotest
