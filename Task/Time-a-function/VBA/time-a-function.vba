Public Declare Function GetTickCount Lib "kernel32.dll" () As Long
Private Function identity(x As Long) As Long
    For j = 0 To 1000
    identity = x
    Next j
End Function
Private Function sum(ByVal num As Long) As Long
    Dim t As Long
    For j = 0 To 1000
    t = num
    For i = 0 To 10000
        t = t + i
    Next i
    Next j
    sum = t
End Function
Private Sub time_it()
    Dim start_time As Long, finis_time As Long
    start_time = GetTickCount
    identity 1
    finis_time = GetTickCount
    Debug.Print "1000 times Identity(1) takes "; (finis_time - start_time); " milliseconds"
    start_time = GetTickCount
    sum 1
    finis_time = GetTickCount
    Debug.Print "1000 times Sum(1) takes "; (finis_time - start_time); " milliseconds"
End Sub
