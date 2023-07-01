Imports System
Imports System.Numerics
				
Public Module Module1
	Public Sub Main()
        Dim two, three, four, seven, ten, k, q, t, l, n, r, nn, nr As BigInteger,
            first As Boolean = True
        two = New BigInteger(2) : three = New BigInteger(3) : four = two + two
        seven = three + four : ten = three + seven : k = BigInteger.One
        q = k : t = k : l = three : n = three : r = BigInteger.Zero
        While True
            If four * q + r - t < n * t Then
                Console.Write(n) : If first Then Console.Write(".") : first = False
                nr = ten * (r - n * t) : n = ten * (three * q + r) / t - ten * n
                q *= ten
            Else
                nr = (two * q + r) * l : nn = (q * seven * k + two + r * l) / (t * l)
                q *= k : t *= l : l += two : k += BigInteger.One : n = nn
            End If
            r = nr
        End While
    End Sub

End Module
