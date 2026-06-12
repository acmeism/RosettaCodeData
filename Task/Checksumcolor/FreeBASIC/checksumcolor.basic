Sub colourhex(s As String)
    For i As Integer = 1 To Len(s)
        Dim As String*1 ch = Mid(s,i,1)
        Dim As Integer k = Instr("123456789ABCDEF", Ucase(ch))
        Color 15-k, k
        Print ch;
    Next
    Color Rgb(255,255,255), Rgb(0,0,0)
End Sub

colourhex("#0123456789ABCDEF")
Sleep
