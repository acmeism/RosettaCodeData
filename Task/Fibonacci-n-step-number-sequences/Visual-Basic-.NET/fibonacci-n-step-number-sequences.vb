' Fibonacci n-step number sequences - VB.Net
Public Class FibonacciNstep

    Const nmax = 20

    Sub Main()
        Dim bonacci As String() = {"", "", "Fibo", "tribo", "tetra", "penta", "hexa"}
        Dim i As Integer
        'Fibonacci:
        For i = 2 To 6
            Debug.Print(bonacci(i) & "nacci: " & FibonacciN(i, nmax))
        Next i
        'Lucas:
        Debug.Print("Lucas: " & FibonacciN(2, nmax, 2))
    End Sub 'Main

    Private Function FibonacciN(iStep As Long, Count As Long, Optional First As Long = 0) As String
        Dim i, j As Integer, Sigma As Long, c As String
        Dim T(nmax) As Long
        T(1) = IIf(First = 0, 1, First)
        T(2) = 1
        For i = 3 To Count
            Sigma = 0
            For j = i - 1 To i - iStep Step -1
                If j > 0 Then
                    Sigma += T(j)
                End If
            Next j
            T(i) = Sigma
        Next i
        c = ""
        For i = 1 To nmax
            c &= ", " & T(i)
        Next i
        Return Mid(c, 3)
    End Function 'FibonacciN

End Class 'FibonacciNstep
