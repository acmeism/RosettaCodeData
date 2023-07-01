Sub Main_With_Class()
Dim Base(2) As New ClassArrayAssociative, Up(2) As New ClassArrayAssociative
    ReDim Result(UBound(Base)) As New ClassArrayAssociative
    'FILL Base & Update
    Base(0).Add "name", "Rocket Skates"
    Base(1).Add "price", 12.75
    Base(2).Add "color", "yellow"
    Result = Base
    Up(0).Add "price", 15.25
    Up(1).Add "color", "red"
    Up(2).Add "year", 1974
    'Update Result with Up
    Update Result, Up
    'Print Out
    Print_Out_2 Result
End Sub
Private Sub Update(R() As ClassArrayAssociative, U() As ClassArrayAssociative)
Dim i As Long, j As Long, Flag As Boolean
    For i = LBound(U) To UBound(U)
        j = LBound(R)
        Flag = False
        Do While j <= UBound(R) And Not Flag
            If R(j).Key = U(i).Key Then
                R(j).Value = U(i).Value
                Flag = True
            End If
            j = j + 1
        Loop
        If Not Flag Then
            ReDim Preserve R(UBound(R) + 1)
            Set R(UBound(R)) = New ClassArrayAssociative
            R(UBound(R)).Add U(i).Key, U(i).Value
        End If
    Next i
End Sub
Private Sub Print_Out_2(A() As ClassArrayAssociative)
Dim i As Long
    Debug.Print "Key", "Value"
    For i = LBound(A) To UBound(A)
        Debug.Print A(i).Key, A(i).Value
    Next i
    Debug.Print "-----------------------------"
End Sub
