Dim funkyArray(7 to 8) As String

Public Function SizeOfArray(ar As Variant) As Long
  SizeOfArray = UBound(ar) - LBound(ar) + 1
End Function

'call the function
Debug.Print "Array Length: " & SizeOfArray(funkyArray)
