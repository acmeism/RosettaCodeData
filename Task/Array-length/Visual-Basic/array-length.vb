' declared in a module
Public Function LengthOfArray(ByRef arr As Variant) As Long
  If IsArray(arr) Then
     LengthOfArray = UBound(arr) - LBound(arr) + 1
  Else
     LengthOfArray = -1
  End If
End Function

' somewhere in the programm
' example 1
  Dim arr As Variant

  arr = Array("apple", "orange")

  Debug.Print LengthOfArray(arr) ' prints 2 as result

' example 2
  Dim arr As Variant

  ReDim arr(-2 To -1)
  arr(-2) = "apple"
  arr(-1) = "orange"

  Debug.Print LengthOfArray(arr) ' prints 2 as result
