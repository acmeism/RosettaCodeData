Private Type Associative
    Key As String
    Value As Variant
End Type
Sub Main_Array_Associative()
Dim BaseArray(2) As Associative, UpdateArray(2) As Associative
    FillArrays BaseArray, UpdateArray
    ReDim Result(UBound(BaseArray)) As Associative
    MergeArray Result, BaseArray, UpdateArray
    PrintOut Result
End Sub
Private Sub MergeArray(Res() As Associative, Base() As Associative, Update() As Associative)
Dim i As Long, Respons As Long
    Res = Base
    For i = LBound(Update) To UBound(Update)
        If Exist(Respons, Base, Update(i).Key) Then
            Res(Respons).Value = Update(i).Value
        Else
            ReDim Preserve Res(UBound(Res) + 1)
            Res(UBound(Res)).Key = Update(i).Key
            Res(UBound(Res)).Value = Update(i).Value
        End If
    Next
End Sub
Private Function Exist(R As Long, B() As Associative, K As String) As Boolean
Dim i As Long
    Do
        If B(i).Key = K Then
            Exist = True
            R = i
        End If
        i = i + 1
    Loop While i <= UBound(B) And Not Exist
End Function
Private Sub FillArrays(B() As Associative, U() As Associative)
    B(0).Key = "name"
    B(0).Value = "Rocket Skates"
    B(1).Key = "price"
    B(1).Value = 12.75
    B(2).Key = "color"
    B(2).Value = "yellow"
    U(0).Key = "price"
    U(0).Value = 15.25
    U(1).Key = "color"
    U(1).Value = "red"
    U(2).Key = "year"
    U(2).Value = 1974
End Sub
Private Sub PrintOut(A() As Associative)
Dim i As Long
    Debug.Print "Key", "Value"
    For i = LBound(A) To UBound(A)
        Debug.Print A(i).Key, A(i).Value
    Next i
    Debug.Print "-----------------------------"
End Sub
