For h = 1 To 20
	WScript.StdOut.Write "H(" & h & ") = " & Hamming(h)
	WScript.StdOut.WriteLine
Next
WScript.StdOut.Write "H(" & 1691 & ") = " & Hamming(1691)
WScript.StdOut.WriteLine

Function Hamming(l)
	Dim h() : Redim h(l) : h(0) = 1
	i = 0 : j = 0 : k = 0
	x2 = 2 : x3 = 3 : x5 = 5
	For n = 1 To l-1
		m = x2
		If m > x3 Then m = x3 End If
		If m > x5 Then m = x5 End If
		h(n) = m
		If m = x2 Then i = i + 1 : x2 = 2 * h(i) End If
		If m = x3 Then j = j + 1 : x3 = 3 * h(j) End If
		If m = x5 Then k = k + 1 : x5 = 5 * h(k) End If
	Next
	Hamming = h(l-1)
End Function
