#define floor(x) ((x*2.0-0.5) Shr 1)

Dim Shared As Double bbase          ' Number bbase being used [9..14]

Sub NumOut(n As Double)             ' Display n in the specified bbase
    Dim As Integer remain = Fix(n Mod bbase)
    n = Floor(n / bbase)
    If n <> 0 Then NumOut(n)
    Print Chr(remain + Iif(remain <= 9, Asc("0"), Asc("A")-10));
End Sub

Sub ShowPenSq(n As Double)          ' Display n = n^2
    NumOut(n)
    'Print Chr(253); " = ";
    Print "^2 = ";
    NumOut(n * n)
    Print "  ";
End Sub

Function isPenholodigital(n As Double) As Boolean
    Dim As Integer used, remain
    used = 1 ' can't contain 0
    While n <> 0
        remain = Fix(n Mod bbase)
        n = Floor(n / bbase)
        If (used And (1 Shl remain)) Then Return False
        used = used Or (1 Shl remain)
    Wend
    Return (used = (1 Shl Fix(bbase)) - 1)
End Function

Dim As Uinteger cnt
Dim As Double n, limite, n1, n2
bbase = 9
Do
    cnt = 0
    n1 = 0
    n = Floor(Sqr(bbase ^ (bbase-2)))
    limite = Sqr(bbase ^ (bbase-1))
    Do
        If isPenholodigital(n * n) Then
            cnt += 1
            If n1 = 0 Then n1 = n
            If bbase <= 12 Then
                ShowPenSq(n)
                If (cnt Mod 3) = 0 Then Print
            Else
                n2 = n
            End If
        End If
        n += 1
    Loop Until n >= limite
    If (cnt Mod 3) <> 0 Then Print
    Print "There are "; cnt; " penholodigital squares in base "; Fix(bbase)
    If bbase >= 13 And cnt > 0 Then
        ShowPenSq(n1)
        Print "..  ";
        ShowPenSq(n2)
    End If
    Print
    bbase += 1
Loop Until bbase >= 15

Sleep
