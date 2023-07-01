Function MinimalLenght(strLine As String) As Integer
Dim myVar As Variant, I As Integer, Flag As Boolean, myColl As Collection, Count As Integer
   myVar = Split(strLine, " ")
   Count = 0
   Do
      Set myColl = New Collection
      Count = Count + 1
      On Error Resume Next
      Do
         myColl.Add Left$(myVar(I), Count), Left$(myVar(I), Count)
         I = I + 1
      Loop While Err.Number = 0 And I <= UBound(myVar)
      Flag = Err.Number = 0
      On Error GoTo 0
      I = 0
      Set myColl = Nothing
   Loop While Not Flag
   MinimalLenght = Count
End Function
