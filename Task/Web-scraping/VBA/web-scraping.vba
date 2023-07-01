Rem add Microsoft VBScript Regular Expression X.X to your Tools References

Function GetUTC() As String
    Url = "http://tycho.usno.navy.mil/cgi-bin/timer.pl"
    With CreateObject("MSXML2.XMLHTTP.6.0")
        .Open "GET", Url, False
        .send
        arrt = Split(.responseText, vbLf)
    End With
    For Each t In arrt
        If InStr(t, "UTC") Then
            GetUTC = StripHttpTags(t)

            Exit For
        End If
    Next
End Function

Function StripHttpTags(s)
    With New RegExp
        .Global = True
        .Pattern = "\<.+?\>"
        If .Test(s) Then
            StripHttpTags = .Replace(s, "")
        Else
            StripHttpTags = s
        End If
    End With
End Function

Sub getTime()
    Rem starting point
    Dim ReturnValue As String
    ReturnValue = GetUTC
    Rem debug.print can be removed
    Debug.Print ReturnValue
    MsgBox (ReturnValue)
End Sub
