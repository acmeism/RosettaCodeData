' Flatten the example array...
a = FlattenArray(Array(Array(1), 2, Array(Array(3,4), 5), Array(Array(Array())), Array(Array(Array(6))), 7, 8, Array()))

' Print the list, comma-separated...
WScript.Echo Join(a, ",")

Function FlattenArray(a)
	If IsArray(a) Then DoFlatten a, FlattenArray: FlattenArray = Split(Trim(FlattenArray))
End Function

Sub DoFlatten(a, s)
	For i = 0 To UBound(a)
		If IsArray(a(i)) Then DoFlatten a(i), s Else s = s & a(i) & " "
	Next
End Sub
