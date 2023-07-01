'function arguments:
'init - initial series of the sequence(e.g. "1,1")
'rep - how many times the sequence repeats - init
Function generate_seq(init,rep)
	token = Split(init,",")
	step_count = UBound(token)
	rep = rep - (UBound(token) + 1)
	out = init
	For i = 1 To rep
		sum = 0
		n = step_count
		Do While n >= 0
			sum = sum + token(UBound(token)-n)
			n = n - 1
		Loop
		'add the next number to the sequence
		ReDim Preserve token(UBound(token) + 1)
		token(UBound(token)) = sum
		out = out & "," & sum
	Next
	generate_seq = out
End Function

WScript.StdOut.Write "fibonacci: " & generate_seq("1,1",15)
WScript.StdOut.WriteLine
WScript.StdOut.Write "tribonacci: " & generate_seq("1,1,2",15)
WScript.StdOut.WriteLine
WScript.StdOut.Write "tetranacci: " & generate_seq("1,1,2,4",15)
WScript.StdOut.WriteLine
WScript.StdOut.Write "lucas: " & generate_seq("2,1",15)
WScript.StdOut.WriteLine
