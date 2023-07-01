    Sub Main()
        'Loops Increment loop index within loop body - 17/07/2018
        Dim imax, i As Integer
        Dim n As Currency
        imax = 42
        i = 0: n = 42
        Do While i < imax
            If IsPrime(n) Then
                i = i + 1
                Debug.Print ("i=" & RightX(i, 2) & " : " & RightX(Format(n, "#,##0"), 20))
                n = n + n - 1
            End If
            n = n + 1
        Loop
    End Sub 'Main

    Function IsPrime(n As Currency)
        Dim i As Currency
        If n = 2 Or n = 3 Then
            IsPrime = True
        ElseIf ModX(n, 2) = 0 Or ModX(n, 3) = 0 Then
            IsPrime = False
        Else
            i = 5
            Do While i * i <= n
                If ModX(n, i) = 0 Or ModX(n, i + 2) = 0 Then
                    IsPrime = False
                    Exit Function
                End If
                i = i + 6
            Loop
            IsPrime = True
        End If
    End Function 'IsPrime

    Function ModX(a As Currency, b As Currency) As Currency
        ModX = a - Int(a / b) * b
    End Function 'ModX

    Function RightX(c, n)
        RightX = Right(Space(n) & c, n)
    End Function 'RightX
