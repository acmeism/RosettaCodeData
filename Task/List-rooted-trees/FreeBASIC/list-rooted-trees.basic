Dim Shared As String*2 list = "()"
Dim Shared As String addstr()
Dim Shared As Boolean flag = False
Dim Shared As String cad, newcad

Sub result(list As String, pn As Integer)
    flag = False
    newcad = list
    While Instr(newcad, "()") <> 0
        If list = "()" Or list = "(())" Then
            flag = True
            Exit Sub
        End If
        Dim As Integer num = Instr(newcad, "()")
        newcad = Left(newcad, num - 1) & Mid(newcad, num + 2)
        If Left(list, 2) = "()" Or Right(list, 2) = "()" Or Left(list, 4) = "(())" Or Right(list, 4) = "(())" Then
            flag = False
            Exit Sub
        Else
            If Len(list) <> 2 And Len(list) <> 4 And newcad = "" Then
                flag = True
                Exit Sub
            End If
        End If
    Wend
End Sub

Sub permutation(list As String, pn As Integer)
    Redim addstr(0)
    Do
        cad = ""
        For n As Integer = 1 To pn
            Dim As Integer rand = Int(Rnd * 2) + 1
            cad &= Mid(list, rand, 1)
        Next
        Dim As Integer found = False
        For m As Integer = 0 To Ubound(addstr)
            If addstr(m) = cad Then
                found = True
                Exit For
            End If
        Next
        If Not found Then
            Redim Preserve addstr(Ubound(addstr) + 1)
            addstr(Ubound(addstr)) = cad
        End If
        If Ubound(addstr) + 1 = 2 ^ pn Then Exit Do
    Loop
End Sub

Sub listroot(pn As Integer)
    For n As Integer = 0 To Ubound(addstr)
        result(addstr(n), pn)
        If flag Then Print "" & addstr(n)
    Next
End Sub

' test cases
Dim As Integer np(5) = {0, 1, 2, 3, 4, 9}
For nr As Integer = 0 To Ubound(np)
    Dim As String bg1 = Iif(nr = 1, "bag", "bags")
    Print !"\nfor " & np(nr) & " " & bg1 & " :"
    permutation(list, nr * 2)
    listroot(nr * 2)
Next

Sleep
