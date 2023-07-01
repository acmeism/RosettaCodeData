Dim a, b, i

Do
    a = Int(Rnd * 20)
    WScript.StdOut.Write a
    If a = 10 Then Exit Do
    b = Int(Rnd * 20)
    WScript.Echo vbNullString, b
Loop

For i = 1 To 100000
    a = Int(Rnd * 20)
    WScript.StdOut.Write a
    If a = 10 Then Exit For
    b = Int(Rnd * 20)
    WScript.Echo vbNullString, b
Next
