#define floor(x) ((x*2.0-0.5) Shr 1)

Dim As Integer c = 0, n = 1
Do While c < 70
    Dim As Integer m = 1
    Do
        Dim As Integer nm = n*m, t = 0
        While nm
            t += nm Mod 10
            nm = floor(nm/10)
        Wend
        If t = n Then Exit Do : End If
        m += 1
    Loop
    c += 1
    Print Using "######## "; m;
    If c Mod 10 = 0 Then Print
    n += 1
Loop
Sleep
