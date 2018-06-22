Option Explicit

Sub Main()
Dim y As Long, m As Long, t As String, cpt As Long, cptm As Long
    For y = 1900 To 2100
        t = vbNullString
        For m = 1 To 12 Step 2
            If m = 9 Then m = 8
            If Weekday(DateSerial(y, m, 1)) = vbFriday Then
                t = t & ", " & m
                cptm = cptm + 1
            End If
        Next
        If t <> "" Then
            Debug.Print y & t
        Else
            cpt = cpt + 1
        End If
    Next
    Debug.Print "There is " & cptm & " months with five full weekends from the year 1900 through 2100"
    Debug.Print "There is " & cpt & " years which don't have months with five weekends"
End Sub
