Public Sub Main()
Dim v As Variant

' initial state: Empty
Debug.Assert IsEmpty(v)
Debug.Assert VarType(v) = vbEmpty

v = 1&
Debug.Assert VarType(v) = vbLong

' assigning the Null state
v = Null
' checking for Null state
Debug.Assert IsNull(v)
Debug.Assert VarType(v) = vbNull

End Sub
