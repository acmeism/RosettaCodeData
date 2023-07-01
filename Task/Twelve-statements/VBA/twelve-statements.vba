Public s As String    '-- (eg "101101100010")
Public t As Integer   '-- scratch

Function s1()
    s1 = Len(s) = 12
End Function
Function s2()
    t = 0
    For i = 7 To 12
        t = t - (Mid(s, i, 1) = "1")
    Next i
    s2 = t = 3
End Function
Function s3()
    t = 0
    For i = 2 To 12 Step 2
        t = t - (Mid(s, i, 1) = "1")
    Next i
    s3 = t = 2
End Function
Function s4()
    s4 = Mid(s, 5, 1) = "0" Or ((Mid(s, 6, 1) = "1" And Mid(s, 7, 1) = "1"))
End Function
Function s5()
    s5 = Mid(s, 2, 1) = "0" And Mid(s, 3, 1) = "0" And Mid(s, 4, 1) = "0"
End Function
Function s6()
    t = 0
    For i = 1 To 12 Step 2
        t = t - (Mid(s, i, 1) = "1")
    Next i
    s6 = t = 4
End Function
Function s7()
    s7 = Mid(s, 2, 1) <> Mid(s, 3, 1)
End Function
Function s8()
    s8 = Mid(s, 7, 1) = "0" Or (Mid(s, 5, 1) = "1" And Mid(s, 6, 1) = "1")
End Function
Function s9()
    t = 0
    For i = 1 To 6
        t = t - (Mid(s, i, 1) = "1")
    Next i
    s9 = t = 3
End Function
Function s10()
    s10 = Mid(s, 11, 1) = "1" And Mid(s, 12, 1) = "1"
End Function
Function s11()
    t = 0
    For i = 7 To 9
        t = t - (Mid(s, i, 1) = "1")
    Next i
    s11 = t = 1
End Function
Function s12()
    t = 0
    For i = 1 To 11
        t = t - (Mid(s, i, 1) = "1")
    Next i
    s12 = t = 4
End Function

Public Sub twelve_statements()
    For i = 0 To 2 ^ 12 - 1
        s = Right(CStr(WorksheetFunction.Dec2Bin(64 + i \ 128)), 5) _
            & Right(CStr(WorksheetFunction.Dec2Bin(256 + i Mod 128)), 7)
        For b = 1 To 12
            Select Case b
                Case 1: If s1 <> (Mid(s, b, 1) = "1") Then Exit For
                Case 2: If s2 <> (Mid(s, b, 1) = "1") Then Exit For
                Case 3: If s3 <> (Mid(s, b, 1) = "1") Then Exit For
                Case 4: If s4 <> (Mid(s, b, 1) = "1") Then Exit For
                Case 5: If s5 <> (Mid(s, b, 1) = "1") Then Exit For
                Case 6: If s6 <> (Mid(s, b, 1) = "1") Then Exit For
                Case 7: If s7 <> (Mid(s, b, 1) = "1") Then Exit For
                Case 8: If s8 <> (Mid(s, b, 1) = "1") Then Exit For
                Case 9: If s9 <> (Mid(s, b, 1) = "1") Then Exit For
                Case 10: If s10 <> (Mid(s, b, 1) = "1") Then Exit For
                Case 11: If s11 <> (Mid(s, b, 1) = "1") Then Exit For
                Case 12: If s12 <> (Mid(s, b, 1) = "1") Then Exit For
            End Select
            If b = 12 Then Debug.Print s
        Next
    Next
End Sub
