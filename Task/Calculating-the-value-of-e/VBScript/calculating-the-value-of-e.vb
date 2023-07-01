e0 = 0 : e = 2 : n = 0 : fact = 1
While (e - e0) > 1E-15
	e0 = e
	n = n + 1
	fact = fact * 2*n * (2*n + 1)
	e = e + (2*n + 2)/fact
Wend

WScript.Echo "Computed e = " & e
WScript.Echo "Real e = " & Exp(1)
WScript.Echo "Error = " & (Exp(1) - e)
WScript.Echo "Number of iterations = " & n
