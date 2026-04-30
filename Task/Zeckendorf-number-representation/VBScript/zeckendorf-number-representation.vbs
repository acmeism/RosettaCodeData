Function Zeckendorf(n)
	num = n
	Set fibonacci = CreateObject("System.Collections.Arraylist")
	fibonacci.Add 1 : fibonacci.Add 2
	i = 1
	Do While fibonacci(i) < num
		fibonacci.Add fibonacci(i) + fibonacci(i-1)
		i = i + 1
	Loop
	tmp = ""
	For j = fibonacci.Count-1 To 0 Step -1
		If fibonacci(j) <= num And (tmp = "" Or Left(tmp,1) <> "1") Then
			tmp = tmp & "1"
			num = num - fibonacci(j)
		Else
			tmp = tmp & "0"
		End If
	Next
	Zeckendorf = CLng(tmp)
End Function

'testing the function
For k = 0 To 20
	WScript.StdOut.WriteLine k & ": " & Zeckendorf(k)
Next
