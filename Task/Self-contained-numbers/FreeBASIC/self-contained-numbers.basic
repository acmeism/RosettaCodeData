Dim As Integer i = 1, c = 0
Dim As Integer res(6)
Dim As Ulongint j

While c < 7
    j = i
    While j <> 1
        If j Mod 2 = 0 Then j \= 2 Else j = 3 * j + 1
        If j Mod i = 0 Then
            res(c) = i
            c += 1
            Exit While
        End If
    Wend
    i += 2
Wend

Print "The first 7 self-contained numbers are:"
For c = 0 To 6
    Print res(c);
Next

Sleep
