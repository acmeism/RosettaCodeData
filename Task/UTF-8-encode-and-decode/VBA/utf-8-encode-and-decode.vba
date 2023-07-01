Private Function unicode_2_utf8(x As Long) As Byte()
    Dim y() As Byte
    Dim r As Long
    Select Case x
        Case 0 To &H7F
            ReDim y(0)
            y(0) = x
        Case &H80 To &H7FF
            ReDim y(1)
            y(0) = 192 + x \ 64
            y(1) = 128 + x Mod 64
        Case &H800 To &H7FFF
            ReDim y(2)
            y(2) = 128 + x Mod 64
            r = x \ 64
            y(1) = 128 + r Mod 64
            y(0) = 224 + r \ 64
        Case 32768 To 65535 '&H8000 To &HFFFF equals in VBA as -32768 to -1
            ReDim y(2)
            y(2) = 128 + x Mod 64
            r = x \ 64
            y(1) = 128 + r Mod 64
            y(0) = 224 + r \ 64
        Case &H10000 To &H10FFFF
            ReDim y(3)
            y(3) = 128 + x Mod 64
            r = x \ 64
            y(2) = 128 + r Mod 64
            r = r \ 64
            y(1) = 128 + r Mod 64
            y(0) = 240 + r \ 64
        Case Else
            MsgBox "what else?" & x & " " & Hex(x)
    End Select
    unicode_2_utf8 = y
End Function
Private Function utf8_2_unicode(x() As Byte) As Long
    Dim first As Long, second As Long, third As Long, fourth As Long
    Dim total As Long
    Select Case UBound(x) - LBound(x)
        Case 0 'one byte
            If x(0) < 128 Then
                total = x(0)
            Else
                MsgBox "highest bit set error"
            End If
        Case 1 'two bytes and assume first byte is leading byte
            If x(0) \ 32 = 6 Then
                first = x(0) Mod 32
                If x(1) \ 64 = 2 Then
                    second = x(1) Mod 64
                Else
                    MsgBox "mask error"
                End If
            Else
                MsgBox "leading byte error"
            End If
            total = 64 * first + second
        Case 2 'three bytes and assume first byte is leading byte
            If x(0) \ 16 = 14 Then
                first = x(0) Mod 16
                If x(1) \ 64 = 2 Then
                    second = x(1) Mod 64
                    If x(2) \ 64 = 2 Then
                        third = x(2) Mod 64
                    Else
                        MsgBox "mask error last byte"
                    End If
                Else
                    MsgBox "mask error middle byte"
                End If
            Else
                MsgBox "leading byte error"
            End If
                total = 4096 * first + 64 * second + third
        Case 3 'four bytes and assume first byte is leading byte
            If x(0) \ 8 = 30 Then
                first = x(0) Mod 8
                If x(1) \ 64 = 2 Then
                    second = x(1) Mod 64
                    If x(2) \ 64 = 2 Then
                        third = x(2) Mod 64
                        If x(3) \ 64 = 2 Then
                            fourth = x(3) Mod 64
                        Else
                            MsgBox "mask error last byte"
                        End If
                    Else
                        MsgBox "mask error third byte"
                    End If
                Else
                    MsgBox "mask error second byte"
                End If
            Else
                MsgBox "mask error leading byte"
            End If
            total = CLng(262144 * first + 4096 * second + 64 * third + fourth)
        Case Else
            MsgBox "more bytes than expected"
        End Select
        utf8_2_unicode = total
End Function
Public Sub program()
    Dim cp As Variant
    Dim r() As Byte, s As String
    cp = [{65, 246, 1046, 8364, 119070}] '[{&H0041,&H00F6,&H0416,&H20AC,&H1D11E}]
    Debug.Print "ch  unicode  UTF-8 encoded  decoded"
    For Each cpi In cp
        r = unicode_2_utf8(CLng(cpi))
        On Error Resume Next
        s = CStr(Hex(cpi))
        Debug.Print ChrW(cpi); String$(10 - Len(s), " "); s,
        If Err.Number = 5 Then Debug.Print "?"; String$(10 - Len(s), " "); s,
        s = ""
        For Each yz In r
            s = s & CStr(Hex(yz)) & " "
        Next yz
        Debug.Print String$(13 - Len(s), " "); s;
        s = CStr(Hex(utf8_2_unicode(r)))
        Debug.Print String$(8 - Len(s), " "); s
    Next cpi
End Sub
