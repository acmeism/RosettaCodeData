Module Module1

    Dim sq As Integer() = {1, 4, 9, 16, 25, 36, 49, 64, 81}

    Function isOne(x As Integer) As Boolean
        While True
            If x = 89 Then Return False
            Dim t As Integer, s As Integer = 0
            Do
                t = (x Mod 10) - 1 : If t >= 0 Then s += sq(t)
                x \= 10
            Loop While x > 0
            If s = 1 Then Return True
            x = s
        End While
        Return False
    End Function

    Sub Main(ByVal args As String())
        Const Max As Integer = 10_000_000
        Dim st As DateTime = DateTime.Now
        Console.Write("---Happy Numbers---" & vbLf & "The first 8:")
        Dim i As Integer = 1, c As Integer = 0
        While c < 8
            If isOne(i) Then Console.Write("{0} {1}", If(c = 0, "", ","), i, c) : c += 1
            i += 1
        End While
        Dim m As Integer = 10
        While m <= Max
            Console.Write(vbLf & "The {0:n0}th: ", m)
            While c < m
                If isOne(i) Then c += 1
                i += 1
            End While
            Console.Write("{0:n0}", i - 1)
            m = m * 10
        End While
        Console.WriteLine(vbLf & "Computation time {0} seconds.", (DateTime.Now - st).TotalSeconds)
    End Sub
End Module
