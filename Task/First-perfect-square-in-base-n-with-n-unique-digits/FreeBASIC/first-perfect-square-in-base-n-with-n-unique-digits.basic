#define floor(x) ((x*2.0-0.5) Shr 1)

Dim Shared As Double n, base_ = 2.  ' Base is a reserved word on FB

Sub NumOut(n As Double)             'Display n in the specified base
    Dim As Integer remainder = Fix(n Mod base_)
    n = floor(n / base_)
    If n <> 0. Then NumOut(n)
    Print Chr(remainder + Iif(remainder <= 9, Asc("0"), Asc("A")-10));
End Sub

Function isPandigital(n As Double) As Boolean
    Dim As Integer used, remainder
    used = 0
    While n <> 0.
        remainder = Fix(n Mod base_)
        n = floor(n / base_)
        used Or= 1 Shl remainder
    Wend
    Return used = (1 Shl Fix(base_)) - 1
End Function

Do
    n = floor(Sqr(base_ ^ (base_-1.)))
    Do
        If isPandigital(n*n) Then
            Print Using "Base ##: "; base_;
            NumOut(n)
            Print "^2 = ";
            NumOut(n*n)
            Print
            Exit Do
        End If
        n += 1.
    Loop
    base_ += 1.
Loop Until base_ > 14.

Sleep
