Module Module1

    ReadOnly max As ULong = 1000000

    Function Kaprekar(n As ULong) As Boolean
        If n = 1 Then Return True

        Dim sq = n * n
        Dim sq_str = Str(sq)
        Dim l = Len(sq_str)

        For x = l - 1 To 1 Step -1
            If sq_str(x) = "0" Then
                l = l - 1
            Else
                Exit For
            End If
        Next

        For x = 1 To l - 1
            Dim p2 = Val(Mid(sq_str, x + 1))
            If p2 > n Then
                Continue For
            End If
            Dim p1 = Val(Left(sq_str, x))
            If p1 > n Then Return False
            If (p1 + p2) = n Then Return True
        Next

        Return False
    End Function

    Sub Main()
        Dim count = 0

        Console.WriteLine("Kaprekar numbers below 10000")

        For n = 1 To max - 1
            If Kaprekar(n) Then
                count = count + 1
                If n < 10000 Then
                    Console.WriteLine("{0,2} {1,4}", count, n)
                End If
            End If
        Next

        Console.WriteLine()
        Console.WriteLine("{0} numbers below {1} are kaprekar numbers", count, max)
    End Sub

End Module
