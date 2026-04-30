sb = Array(1,1)
i = 1 'considered
j = 2 'precedent
n = 0 'loop counter
Do
	ReDim Preserve sb(UBound(sb) + 1)
	sb(UBound(sb)) = sb(UBound(sb) - i) + sb(UBound(sb) - j)
	ReDim Preserve sb(UBound(sb) + 1)
	sb(UBound(sb)) = sb(UBound(sb) - j)
	i = i + 1
	j = j + 1
	n = n + 1
Loop Until n = 2000

WScript.Echo "First 15: " & DisplayElements(15)

For k = 1 To 10
	WScript.Echo "The first instance of " & k & " is in #" & ShowFirstInstance(k) & "."
Next

WScript.Echo "The first instance of " & 100 & " is in #" & ShowFirstInstance(100) & "."

Function DisplayElements(n)
	For i = 0 To n - 1
		If i < n - 1 Then
			DisplayElements = DisplayElements & sb(i) & ", "
		Else
			DisplayElements = DisplayElements & sb(i)
		End If
	Next
End Function

Function ShowFirstInstance(n)
	For i = 0 To UBound(sb)
		If sb(i) = n Then
			ShowFirstInstance = i + 1
			Exit For
		End If
	Next
End Function
