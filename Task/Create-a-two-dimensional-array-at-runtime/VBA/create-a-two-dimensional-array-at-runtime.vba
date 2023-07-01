Option Explicit

Sub Main_Create_Array()
Dim NbColumns As Integer, NbRows As Integer

    'Get two integers from the user,
    Do
        NbColumns = Application.InputBox("Enter number of columns : ", "Numeric only", 3, Type:=1)
        NbRows = Application.InputBox("Enter number of rows : ", "Numeric only", 5, Type:=1)
    Loop While NbColumns = 0 Or NbRows = 0
    'Create a two-dimensional array at runtime
    ReDim myArray(1 To NbRows, 1 To NbColumns)
    'Write some element of that array,
    myArray(LBound(myArray, 1), UBound(myArray, 2)) = "Toto"
    'and then output that element.
    MsgBox myArray(LBound(myArray, 1), UBound(myArray, 2))
    'destroy the array
    Erase myArray
End Sub
