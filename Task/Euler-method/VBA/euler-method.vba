Private Sub ivp_euler(f As String, y As Double, step As Integer, end_t As Integer)
    Dim t As Integer
    Debug.Print " Step "; step; ": ",
    Do While t <= end_t
        If t Mod 10 = 0 Then Debug.Print Format(y, "0.000"),
        y = y + step * Application.Run(f, y)
        t = t + step
    Loop
    Debug.Print
End Sub

Sub analytic()
    Debug.Print "    Time: ",
    For t = 0 To 100 Step 10
        Debug.Print " "; t,
    Next t
    Debug.Print
    Debug.Print "Analytic: ",
    For t = 0 To 100 Step 10
        Debug.Print Format(20 + 80 * Exp(-0.07 * t), "0.000"),
    Next t
    Debug.Print
End Sub

Private Function cooling(temp As Double) As Double
    cooling = -0.07 * (temp - 20)
End Function

Public Sub euler_method()
    Dim r_cooling As String
    r_cooling = "cooling"
    analytic
    ivp_euler r_cooling, 100, 2, 100
    ivp_euler r_cooling, 100, 5, 100
    ivp_euler r_cooling, 100, 10, 100
End Sub
