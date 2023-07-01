Function Divide(Dividend As Integer, Divisor As Integer, ByRef Result As Double) As Boolean
    Divide = True
    On Error Resume Next
    Result = Dividend / Divisor
    If Err <> 0 Then
        Divide = False
        On Error GoTo 0
    End If
End Function

'For use :
Sub test_Divide()
Dim R As Double, Ddd As Integer, Dvs As Integer, B As Boolean

    Ddd = 10: Dvs = 3
    B = Divide(Ddd, Dvs, R)
    Debug.Print "Divide return : " & B & " Result = " & R
    Ddd = 10: Dvs = 0
    B = Divide(Ddd, Dvs, R)
    Debug.Print "Divide return : " & B & " Result = " & R
End Sub
