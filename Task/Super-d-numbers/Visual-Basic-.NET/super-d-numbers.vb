Imports System.Numerics

Module Module1

    Sub Main()
        Dim rd = {"22", "333", "4444", "55555", "666666", "7777777", "88888888", "999999999"}
        Dim one As BigInteger = 1
        Dim nine As BigInteger = 9

        For ii = 2 To 9
            Console.WriteLine("First 10 super-{0} numbers:", ii)
            Dim count = 0

            Dim j As BigInteger = 3
            While True
                Dim k = ii * BigInteger.Pow(j, ii)
                Dim ix = k.ToString.IndexOf(rd(ii - 2))
                If ix >= 0 Then
                    count += 1
                    Console.Write("{0} ", j)
                    If count = 10 Then
                        Console.WriteLine()
                        Console.WriteLine()
                        Exit While
                    End If
                End If

                j += 1
            End While
        Next
    End Sub

End Module
