Dim lookupTable(170), returnTable(170), currentPosition, input
currentPosition = 0

Do While True
	input = InputBox("Please type a number (-1 to quit):")
	MsgBox "The factorial of " & input & " is " & factorial(CDbl(input))
Loop

Function factorial (x)
	If x = -1 Then
		WScript.Quit 0
	End If
	Dim temp
	temp = lookup(x)
	If x <= 1 Then
		factorial = 1
	ElseIf temp <> 0 Then
		factorial = temp
	Else
		temp = factorial(x - 1) * x
		store x, temp
		factorial = temp
	End If
End Function

Function lookup (x)
	Dim i
	For i = 0 To currentPosition - 1
		If lookupTable(i) = x Then
			lookup = returnTable(i)
			Exit Function
		End If
	Next
	lookup = 0
End Function

Function store (x, y)
	lookupTable(currentPosition) = x
	returnTable(currentPosition) = y
	currentPosition = currentPosition + 1
End Function
