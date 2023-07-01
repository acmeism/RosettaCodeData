For year = 2008 To 2121
    If Weekday(DateSerial(year, 12, 25)) = 1 Then
        WScript.Echo year
    End If
Next
