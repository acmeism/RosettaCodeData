Sub mersenne()
    Dim q As Long, k As Long, p As Long, d As Long
    Dim factor As Long, i As Long, y As Long, z As Long
    Dim prime As Boolean
    q = 929   'input value
    For k = 1 To 1048576   '2**20
        p = 2 * k * q + 1
        If (p And 7) = 1 Or (p And 7) = 7 Then    'p=*001 or p=*111
            'p is prime?
            prime = False
            If p Mod 2 = 0 Then GoTo notprime
            If p Mod 3 = 0 Then GoTo notprime
            d = 5
            Do While d * d <= p
                If p Mod d = 0 Then GoTo notprime
                d = d + 2
                If p Mod d = 0 Then GoTo notprime
                d = d + 4
            Loop
            prime = True
        notprime:   'modpow
            i = q: y = 1: z = 2
            Do While i   'i <> 0
                On Error GoTo okfactor
                If i And 1 Then y = (y * z) Mod p  'test first bit
                z = (z * z) Mod p
                On Error GoTo 0
                i = i \ 2
            Loop
            If prime And y = 1 Then factor = p: GoTo okfactor
        End If
    Next k
    factor = 0
okfactor:
    Debug.Print "M" & q, "factor=" & factor
End Sub
