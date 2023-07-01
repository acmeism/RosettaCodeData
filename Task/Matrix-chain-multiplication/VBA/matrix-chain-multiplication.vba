Option Explicit
Option Base 1
Dim N As Long, U() As Long, V() As Long
Sub Optimize(A As Variant)
    Dim I As Long, J As Long, K As Long, C As Long
    N = UBound(A) - 1
    ReDim U(N, N), V(N, N)
    For I = 1 To N
        U(I, 1) = -1
        V(I, 1) = 0
    Next I

    For J = 2 To N
        For I = 1 To N - J + 1
            V(I, J) = &H7FFFFFFF
            For K = 1 To J - 1
                C = V(I, K) + V(I + K, J - K) + A(I) * A(I + K) * A(I + J)
                If C < V(I, J) Then
                    U(I, J) = K
                    V(I, J) = C
                End If
            Next K
        Next I
    Next J

    Debug.Print V(1, N);
    Call Aux(1, N)
    Debug.Print
    Erase U, V
End Sub
Sub Aux(I As Long, J As Long)
    Dim K As Long
    K = U(I, J)
    If K < 0 Then
        Debug.Print CStr(I);
    Else
        Debug.Print "(";
        Call Aux(I, K)
        Debug.Print "*";
        Call Aux(I + K, J - K)
        Debug.Print ")";
    End If
End Sub
Sub Test()
    Call Optimize(Array(5, 6, 3, 1))
    Call Optimize(Array(1, 5, 25, 30, 100, 70, 2, 1, 100, 250, 1, 1000, 2))
    Call Optimize(Array(1000, 1, 500, 12, 1, 700, 2500, 3, 2, 5, 14, 10))
End Sub
