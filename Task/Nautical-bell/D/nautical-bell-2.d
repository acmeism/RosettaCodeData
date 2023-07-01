Dim As Byte m = 0
For n As Byte = 0 To 23
    If n = 23 Then
        Print " 23" + ":30" + " = " + "7 bells"
    Else
        m += 1
        Print ""; n Mod 23; ":30"; " ="; m; " bells"
    End If
    If n = 23 Then
        Print " 00" + ":00" + " = " + "8 bells"
    Else
        m += 1
        Print ""; (n Mod 23+1); ":00"; " ="; m; " bells"
        If m = 8 Then  m = 0
    End If
Next n
Sleep
