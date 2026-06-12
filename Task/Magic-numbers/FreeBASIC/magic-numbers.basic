Function lmod(n As String, d As Integer) As Ulongint
    Dim As Ulongint r = 0
    For i As Integer = 1 To Len(n)
        r = (r * 10 + Val(Mid(n, i, 1))) Mod d
    Next i
    Return r
End Function

Function isPandigital(d As Integer, n As String) As Boolean
    While d < 10
        If Instr(n, Trim(Str(d))) = 0 Then Return False
        d += 1
    Wend
    Return True
End Function

Dim Shared As String res(1 To 1000000)
Dim As Integer i, o, l, d, nn
Dim As String pd1, pd0, n, m

i = 0 : o = 0
Do
    n = res(i + 1)
    l = Len(n) + 1
    For d = 0 To 9
        If (lmod(n & Trim(Str(d)), l) = 0) Then
            o += 1
            res(o) = n & Trim(Str(d))
        End If
    Next d
    i += 1
Loop Until i = o

Print "Found "; o; " magic numbers"
Print !"\nThe largest one is "; res(o)

Print !"\ncount by number of digits:"
l = 0
For i = 1 To o
    m = res(i)
    d = Len(m)
    If d = l Then
        nn += 1
    Else
        If l Then Print Using "## : &"; l; nn
        nn = 1
        l = d
    End If
    If l =  9 And isPandigital(1, m) Then pd1 &= " " & m
    If l = 10 And isPandigital(0, m) Then pd0 &= " " & m
Next i
Print Using "## : &"; l; nn

Print !"\nminimally pandigital in 1..9:" & pd1
Print "minimally pandigital in 0..9:" & pd0

Sleep
