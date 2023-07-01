Option Strict On
Option Explicit On

Module WilsonPrimes

    Function isPrime(p As Integer) As Boolean
        If p < 2 Then Return False
        If p Mod 2 = 0 Then Return p = 2
        IF p Mod 3 = 0 Then Return p = 3
        Dim d As Integer = 5
        Do While d * d <= p
            If p Mod d = 0 Then
                Return False
            Else
                d = d + 2
            End If
        Loop
        Return True
    End Function

    Function isWilson(n As Integer, p As Integer) As Boolean
        If p < n Then Return False
        Dim prod As Long = 1
        Dim p2 As Long = p * p
        For i = 1 To n - 1
            prod = (prod * i) Mod p2
        Next i
        For i = 1 To p - n
            prod = (prod * i) Mod p2
        Next i
        prod = (p2 + prod - If(n Mod 2 = 0, 1, -1)) Mod p2
        Return prod = 0
    End Function

    Sub Main()
        Console.Out.WriteLine(" n:      Wilson primes")
        Console.Out.WriteLine("----------------------")
        For n = 1 To 11
            Console.Out.Write(n.ToString.PadLeft(2) & ":      ")
            If isWilson(n, 2) Then Console.Out.Write("2 ")
            For p = 3 TO 10499 Step 2
                If isPrime(p) And isWilson(n, p) Then Console.Out.Write(p & " ")
            Next p
            Console.Out.WriteLine()
        Next n
    End Sub

End Module
