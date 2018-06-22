Function Multiple_Divide(Dividend As Integer, Divisor As Integer, ParamArray numbers() As Variant) As Long
Dim i As Integer

    On Error GoTo ErrorHandler
    numbers(LBound(numbers)) = Dividend / Divisor
    For i = LBound(numbers) + 1 To UBound(numbers)
        numbers(i) = numbers(i - 1) / Divisor
    Next i
    Multiple_Divide = 1: Exit Function
ErrorHandler:
    Multiple_Divide = 0
End Function

'For use :
Sub test_Multiple_Divide()
Dim Arr(3) As Variant, Ddd As Integer, Dvs As Integer, L As Long, i As Integer

    Ddd = 10: Dvs = 3
    L = Multiple_Divide(Ddd, Dvs, Arr(0), Arr(1), Arr(2), Arr(3))
    Debug.Print "The function return : " & L
    Debug.Print "The values in return are : "
    For i = LBound(Arr) To UBound(Arr)
        Debug.Print Arr(i)
    Next i
    Erase Arr
    Debug.Print "--------------------------------------"
    Ddd = 10: Dvs = 0
    L = Multiple_Divide(Ddd, Dvs, Arr(0), Arr(1), Arr(2), Arr(3))
    Debug.Print "The function return : " & L
    Debug.Print "The values in return are : "
    For i = LBound(Arr) To UBound(Arr)
        Debug.Print IIf(Arr(i) = "", "vbNullString", "Null")
    Next i
End Sub
