Dim prod As Long, sum As Long
Public Sub LoopsWithMultipleRanges()
    Dim x As Integer, y As Integer, z As Integer, one As Integer, three As Integer, seven As Integer, j As Long
    prod = 1
    sum = 0
    x = 5
    y = -5
    z = -2
    one = 1
    three = 3
    seven = 7
    For j = -three To pow(3, 3) Step three: Call process(j): Next j
    For j = -seven To seven Step x: Call process(j): Next j
    For j = 555 To 550 - y: Call process(j): Next j
    For j = 22 To -28 Step -three: Call process(j): Next j
    For j = 1927 To 1939: Call process(j): Next j
    For j = x To y Step z: Call process(j): Next j
    For j = pow(11, x) To pow(11, x) + one: Call process(j): Next j
    Debug.Print " sum= " & Format(sum, "#,##0")
    Debug.Print "prod= " & Format(prod, "#,##0")
End Sub
Private Function pow(x As Long, y As Integer) As Long
    pow = WorksheetFunction.Power(x, y)
End Function
Private Sub process(x As Long)
    sum = sum + Abs(x)
    If Abs(prod) < pow(2, 27) And x <> 0 Then prod = prod * x
End Sub
