' Combinations and permutations - 10/04/2017
Imports System.Numerics 'BigInteger
Module CombPermRc

    Sub Main()
        Dim i, j As Long
        For i = 1 To 12
            For j = 1 To i
                Console.Write("P(" & i & "," & j & ")=" & PermBig(i, j).ToString & "  ")
            Next j
            Console.WriteLine("")
        Next i
        Console.WriteLine("--")
        For i = 10 To 60 Step 10
            For j = 1 To i Step i \ 5
                Console.Write("C(" & i & "," & j & ")=" & CombBig(i, j).ToString & "  ")
            Next j
            Console.WriteLine("")
        Next i
        Console.WriteLine("--")
        For i = 5000 To 15000 Step 5000
            For j = 4000 To 5000 Step 1000
                Console.Write("P(" & i & "," & j & ")=" & PermBig(i, j).ToString("E") & "  ")
            Next j
            Console.WriteLine("")
        Next i
        Console.WriteLine("--")
        For i = 5000 To 15000 Step 5000
            For j = 4000 To 5000 Step 1000
                Console.Write("C(" & i & "," & j & ")=" & CombBig(i, j).ToString("E") & "  ")

            Next j
            Console.WriteLine("")
        Next i
        Console.WriteLine("--")
        i = 5000 : j = 4000
        Console.WriteLine("C(" & i & "," & j & ")=" & CombBig(i, j).ToString)
    End Sub 'Main

    Function PermBig(x As Long, y As Long) As BigInteger
        Dim i As Long, z As BigInteger
        z = 1
        For i = x - y + 1 To x
            z = z * i
        Next i
        Return (z)
    End Function 'PermBig

    Function FactBig(x As Long) As BigInteger
        Dim i As Long, z As BigInteger
        z = 1
        For i = 2 To x
            z = z * i
        Next i
        Return (z)
    End Function 'FactBig

    Function CombBig(ByVal x As Long, ByVal y As Long) As BigInteger
        If y > x Then
            Return (0)
        ElseIf x = y Then
            Return (1)
        Else
            If x - y < y Then y = x - y
            Return (PermBig(x, y) / FactBig(y))
        End If
    End Function 'CombBig

End Module
