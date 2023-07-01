count = 0
firsteigth=""
For i = 1 To 100
	If IsHappy(CInt(i)) Then
		firsteight = firsteight & i & ","
		count = count + 1
	End If
	If count = 8 Then
		Exit For
	End If
Next
WScript.Echo firsteight

Function IsHappy(n)
	IsHappy = False
	m = 0
	Do Until m = 60
		sum = 0
		For j = 1 To Len(n)
			sum = sum + (Mid(n,j,1))^2
		Next
		If sum = 1 Then
			IsHappy = True
			Exit Do
		Else
			n = sum
			m = m + 1
		End If
	Loop
End Function
