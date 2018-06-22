Option Explicit

Sub MainDayOfTheWeek()
    Debug.Print "Xmas will be a Sunday in : " & XmasSunday(2008, 2121)
End Sub

Private Function XmasSunday(firstYear As Integer, lastYear As Integer) As String
Dim i As Integer, temp$
    For i = firstYear To lastYear
        If Weekday(CDate("25/12/" & i)) = vbSunday Then temp = temp & ", " & i
    Next
    XmasSunday = Mid(temp, 2)
End Function
