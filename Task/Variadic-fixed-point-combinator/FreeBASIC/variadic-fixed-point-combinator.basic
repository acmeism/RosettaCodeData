Declare Function Even(n As Integer) As Integer
Declare Function Odd(n As Integer) As Integer

Function Even(n As Integer) As Integer
    If n = 0 Then Return 1
    Return Odd(n - 1)
End Function

Function Odd(n As Integer) As Integer
    If n = 0 Then Return 0
    Return Even(n - 1)
End Function

Function Collatz(n As Integer) As Integer
    Dim As Integer d = 0
    While n <> 1
        n = Iif(n Mod 2 = 0, n \ 2, 3 * n + 1)
        d += 1
    Wend
    Return d
End Function

Dim As String e, o
Dim As Integer i, c
For i = 1 To 10
    e = Iif(Even(i), "True ", "False")
    o = Iif(Odd(i),  "True ", "False")
    c = Collatz(i)
    Print Using "##: Even: &  Odd: &  Collatz: &"; i; e; o; c
Next i

Sleep
