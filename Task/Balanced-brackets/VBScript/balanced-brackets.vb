For n = 1 To 10
	sequence = Generate_Sequence(n)
	WScript.Echo sequence & " is " & Check_Balance(sequence) & "."
Next

Function Generate_Sequence(n)
	For i = 1 To n
		j = Round(Rnd())
		If j = 0 Then
			Generate_Sequence = Generate_Sequence & "["
		Else
			Generate_Sequence = Generate_Sequence & "]"
		End If
	Next
End Function

Function Check_Balance(s)
	Set Stack = CreateObject("System.Collections.Stack")
	For i = 1 To Len(s)
		char = Mid(s,i,1)
		If i = 1 Or char = "[" Then
			Stack.Push(char)
		ElseIf Stack.Count <> 0 Then
			If char = "]" And Stack.Peek = "[" Then
				Stack.Pop
			End If
		Else
			Stack.Push(char)
		End If
	Next
	If Stack.Count > 0 Then
		Check_Balance = "Not Balanced"
	Else
		Check_Balance = "Balanced"
	End If
End Function
