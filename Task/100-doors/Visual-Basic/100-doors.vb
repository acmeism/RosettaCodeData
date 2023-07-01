Public Sub Doors100()
  ' the state of a door is represented by the data type boolean (false = door closed, true = door opened)
  Dim doorstate(1 To 100) As Boolean ' the doorstate()-array is initialized by VB with value 'false'
  Dim i As Long, j As Long

  For i = 1 To 100
      For j = i To 100 Step i
          doorstate(j) = Not doorstate(j)
      Next j
  Next i

  Debug.Print "The following doors are open:"
  For i = 1 To 100
      ' print number if door is openend
      If doorstate(i) Then Debug.Print CStr(i)
  Next i
End Sub
