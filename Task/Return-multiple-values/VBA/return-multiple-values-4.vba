Function List() As String()
Dim i&, Temp(9) As String

    For i = 0 To 9
        Temp(i) = "Liste " & i + 1
    Next
    List = Temp
End Function

'For use :
Sub test_List()
Dim myArr() As String, i As Integer
'Note : you don't need to Dim your array !
    myArr = List()
    For i = LBound(myArr) To UBound(myArr)
        Debug.Print myArr(i)
    Next
End Sub
