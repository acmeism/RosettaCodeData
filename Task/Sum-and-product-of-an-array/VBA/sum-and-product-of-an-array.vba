Sub Demo()
Dim arr
    arr = Array(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
    Debug.Print "sum : " & Application.WorksheetFunction.Sum(arr)
    Debug.Print "product : " & Application.WorksheetFunction.Product(arr)
End Sub
