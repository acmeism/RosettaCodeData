'N-queens problem - non recursive & structured - vba - 26/02/2017
Sub n_queens()
    Const l = 15  'number of queens
    Const b = False  'print option
    Dim a(l), s(l), u(4 * l - 2)
    Dim n, m, i, j, p, q, r, k, t, z
    For i = 1 To UBound(a): a(i) = i: Next i
    For n = 1 To l
        m = 0
        i = 1
        j = 0
        r = 2 * n - 1
        Do
            i = i - 1
            j = j + 1
            p = 0
            q = -r
            Do
                i = i + 1
                u(p) = 1
                u(q + r) = 1
                z = a(j): a(j) = a(i): a(i) = z  'Swap a(i), a(j)
                p = i - a(i) + n
                q = i + a(i) - 1
                s(i) = j
                j = i + 1
            Loop Until j > n Or u(p) Or u(q + r)
            If u(p) = 0 Then
                If u(q + r) = 0 Then
                    m = m + 1  'm: number of solutions
                    If b Then
                        Debug.Print "n="; n; "m="; m
                        For k = 1 To n
                            For t = 1 To n
                                Debug.Print IIf(a(n - k + 1) = t, "Q", ".");
                            Next t
                            Debug.Print
                        Next k
                    End If
                End If
            End If
            j = s(i)
            Do While j >= n And i <> 0
                Do
                    z = a(j): a(j) = a(i): a(i) = z  'Swap a(i), a(j)
                    j = j - 1
                Loop Until j < i
                i = i - 1
                p = i - a(i) + n
                q = i + a(i) - 1
                j = s(i)
                u(p) = 0
                u(q + r) = 0
            Loop
        Loop Until i = 0
        Debug.Print n, m  'number of queens, number of solutions
    Next n
End Sub 'n_queens
