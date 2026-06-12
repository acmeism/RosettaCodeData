Function RiceEncode(n As Integer, k As Integer = 2, extended As Boolean = False) As String
    If extended Then n = Iif(n < 0, -2*n-1, 2*n)
    Dim As Integer m = 2 ^ k
    Dim As Integer q = n \ m
    Dim As Integer r = n Mod m
    Return String(q, "1") & Right("00000000" & Bin(r), k + 1)
End Function

Function RiceDecode(a As String, k As Integer = 2, extended As Boolean = False) As Integer
    Dim As Integer m = 2 ^ k
    Dim As Integer q = Instr(a, "0") - 1
    Dim As Integer r = Val("&B" & Mid(a, q + 2))
    Dim As Integer i = q * m + r
    If extended Then i = Iif(i Mod 2, -(i +1) \ 2, i \ 2)
    Return i
End Function

Dim As Integer n
Dim As String s
Print "Base Rice Coding:"
For n = 0 To 10
    s = RiceEncode(n)
    Print Using "& -> & -> &"; n; s; RiceDecode(s)
Next n
Print "Extended Rice Coding:"
For n = -10 To 10
    s = RiceEncode(n, 2, True)
    Print Using "& -> & -> &"; n; s; RiceDecode(s, 2, True)
Next n

Sleep
