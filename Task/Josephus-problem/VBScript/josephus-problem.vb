Function josephus(n,k,s)
	Set prisoner = CreateObject("System.Collections.ArrayList")
	For i = 0 To n - 1
		prisoner.Add(i)
	Next
	index = -1
	Do Until prisoner.Count = s
		step_count = 0
		Do Until step_count = k
			If index+1 <= prisoner.Count-1 Then
				index = index+1
			Else
				index = (index+1)-(prisoner.Count)
			End If
			step_count = step_count+1
		Loop
		prisoner.RemoveAt(index)
		index = index-1
	Loop
	For j = 0 To prisoner.Count-1
		If j < prisoner.Count-1 Then
			josephus = josephus & prisoner(j) & ","
		Else
			josephus = josephus & prisoner(j)
		End If
	Next
End Function

'testing the function
WScript.StdOut.WriteLine josephus(5,2,1)
WScript.StdOut.WriteLine josephus(41,3,1)
WScript.StdOut.WriteLine josephus(41,3,3)
