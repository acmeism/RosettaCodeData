Function ModPow(b As Uinteger, e As Uinteger, m As Uinteger) As Uinteger
    Dim As Uinteger p = 1
    While e <> 0
        If (e And 1) Then p = (p*b) Mod m
        b = (b*b) Mod m
        e Shr= 1
    Wend
    Return p
End Function

Function isDeceptive(n As Uinteger) As Uinteger
    Dim As Uinteger x
    If (n And 1) <> 0 Andalso (n Mod 3) <> 0 Andalso (n Mod 5) <> 0 Then
        x = 7
        While x*x <= n
            If (n Mod x) = 0 Orelse (n Mod (x+4)) = 0 Then Return (ModPow(10, n-1, n) = 1)
            x += 6
        Wend
    End If
    Return 0
End Function

Dim As Uinteger c = 0, i = 49
While c <> 41 ' limit for signed 32-bit integers
    If isDeceptive(i) Then
        Print Using "#######"; Csng(i);
        c += 1
        If (c Mod 10) = 0 Then Print
    End If
    i += 1
Wend

Sleep
