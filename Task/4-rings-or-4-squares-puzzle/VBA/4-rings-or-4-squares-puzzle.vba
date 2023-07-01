Dim a As Integer, b As Integer, c As Integer, d As Integer
Dim e As Integer, f As Integer, g As Integer
Dim lo As Integer, hi As Integer, unique As Boolean, show As Boolean
Dim solutions As Integer
Private Sub bf()
    For f = lo To hi
        If ((Not unique) Or _
            ((f <> a And f <> c And f <> d And f <> g And f <> e))) Then
            b = e + f - c
            If ((b >= lo) And (b <= hi) And _
                ((Not unique) Or ((b <> a) And (b <> c) And _
                (b <> d) And (b <> g) And (b <> e) And (b <> f)))) Then
                solutions = solutions + 1
                If show Then Debug.Print a; b; c; d; e; f; g
            End If
        End If
    Next
End Sub
Private Sub ge()
    For e = lo To hi
        If ((Not unique) Or ((e <> a) And (e <> c) And (e <> d))) Then
            g = d + e
            If ((g >= lo) And (g <= hi) And _
                ((Not unique) Or ((g <> a) And (g <> c) And _
                (g <> d) And (g <> e)))) Then
                bf
            End If
        End If
    Next
End Sub
Private Sub acd()
    For c = lo To hi
        For d = lo To hi
            If ((Not unique) Or (c <> d)) Then
                a = c + d
                If ((a >= lo) And (a <= hi) And _
                    ((Not unique) Or ((c <> 0) And (d <> 0)))) Then
                    ge
                End If
            End If
        Next d
    Next c
End Sub
Private Sub foursquares(plo As Integer, phi As Integer, punique As Boolean, pshow As Boolean)
    lo = plo
    hi = phi
    unique = punique
    show = pshow
    solutions = 0
    acd
    Debug.Print
    If unique Then
        Debug.Print solutions; " unique solutions in"; lo; "to"; hi
    Else
        Debug.Print solutions; " non-unique solutions in"; lo; "to"; hi
    End If
End Sub
Public Sub program()
    Call foursquares(1, 7, True, True)
    Debug.Print
    Call foursquares(3, 9, True, True)
    Call foursquares(0, 9, False, False)
End Sub
