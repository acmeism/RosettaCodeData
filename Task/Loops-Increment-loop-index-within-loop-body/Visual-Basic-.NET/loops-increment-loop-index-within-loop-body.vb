Module LoopsIliwlb

    Sub Main()
        'Loops Increment loop index within loop body - 17/07/2018
        Dim imax, i As Int32
        Dim n As Int64
        imax = 42
        i = 0 : n = 42
        While i < imax
            If IsPrime(n) Then
                i = i + 1
                Console.WriteLine("i=" & RightX(i, 2) & " : " & RightX(Format(n, "#,##0"), 20))
                n = n + n - 1
            End If
            n = n + 1
        End While
    End Sub

    Function IsPrime(n As Int64)
        Dim i As Int64
        If n = 2 Or n = 3 Then
            IsPrime = True
        ElseIf (n Mod 2) = 0 Or (n Mod 3) = 0 Then
            IsPrime = False
        Else
            i = 5
            While i * i <= n
                If (n Mod i) = 0 Or (n Mod (i + 2)) = 0 Then
                    IsPrime = False
                    Exit Function
                End If
                i = i + 6
            End While
            IsPrime = True
        End If
    End Function 'IsPrime

    Function RightX(c, n)
        RightX = Right(Space(n) & c, n)
    End Function

End Module
