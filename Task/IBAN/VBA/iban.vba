Public nations As New Collection
Private Sub init()
    nations.Add 24, "AD"
    nations.Add 21, "CH"
    nations.Add 22, "GB"
    nations.Add 24, "SA"
    nations.Add 20, "XK"
End Sub

Private Function mod97(ByVal c As String) As Integer
    Dim n As Long
    n = Val(Mid(c, 1, 9))
    c = Mid(c, 10, Len(c) - 9)
    n = n Mod 97
    Do While Len(c) > 6
        n = Val(Str(n) & Mid(c, 1, 7))
        n = n Mod 97
        c = Mid(c, 8, Len(c) - 7)
    Loop
    n = Val(Str(n) & c)
    mod97 = n Mod 97
End Function

Private Function iban(ByVal code As String) As Boolean
'-- This routine does and should reject codes containing spaces etc.
'-- Use iban_s() below for otherwise.
    On Error GoTo 1
    lengths = nations(Mid(code, 1, 2))
    If Len(code) = lengths Then
        code = code & Mid(code, 1, 4)
        code = Mid(code, 5, lengths)
        Dim c As String: c = ""
        Dim ch As String
        For i = 1 To lengths
            ch = Mid(code, i, 1)
            If ch >= "0" And ch <= "9" Then
                c = c & ch
            Else
                If ch >= "A" And ch <= "Z" Then
                    c = c & Str(Asc(ch) - 55)
                Else
                    iban = False
                End If
            End If
        Next i
        c = Replace(c, " ", "")
        iban = mod97(c) = 1
    End If
    Exit Function
1:
    iban = False
End Function

Private Function iban_s(code As String) As Boolean
'-- strips any embedded spaces and hyphens before validating.
    code = Replace(code, " ", "")
    code = Replace(code, "-", "")
    iban_s = iban(code)
End Function

Private Sub test(code As String, expected As Boolean)
    Dim valid As Boolean
    valid = iban_s(code)
    Dim state As String
    If valid = expected Then
        state = IIf(valid, "ok", "invalid (as expected)")
    Else
        state = IIf(valid, "OK!!", "INVALID!!") & " (NOT AS EXPECTED)"
    End If
    Debug.Print code, state
End Sub

Public Sub main()
    init
    test "GB82 WEST 1234 5698 7654 32", True
    test "GB82 TEST 1234 5698 7654 32", False
    test "GB81 WEST 1234 5698 7654 32", False
    test "SA03 8000 0000 6080 1016 7519", True
    test "CH93 0076 2011 6238 5295 7", True
End Sub
