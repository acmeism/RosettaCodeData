Option Explicit

Sub Main()
Dim Div
    If CatchDivideByZero(152, 0, Div) Then Debug.Print Div Else Debug.Print "Error"
    If CatchDivideByZero(152, 10, Div) Then Debug.Print Div Else Debug.Print "Error"
End Sub

Function CatchDivideByZero(Num, Den, Div) As Boolean
    On Error Resume Next
    Div = Num / Den
    If Err = 0 Then CatchDivideByZero = True
    On Error GoTo 0
End Function
