Option Explicit

Sub Main()
Dim T#
    T = Timer
    Debug.Print SumMult3and5VBScript(100000000) & "   " & Format(Timer - T, "0.000 sec.")
    T = Timer
    Debug.Print SumMult3and5(100000000) & "   " & Format(Timer - T, "0.000 sec.")
    T = Timer
    Debug.Print SumMult3and5BETTER(100000000) & "   " & Format(Timer - T, "0.000 sec.")
    Debug.Print "-------------------------"
    Debug.Print SumMult3and5BETTER(1000)
End Sub
