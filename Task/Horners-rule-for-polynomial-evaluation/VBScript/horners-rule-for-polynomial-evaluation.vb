Function horners_rule(coefficients,x)
	accumulator = 0
	For i = UBound(coefficients) To 0 Step -1
		accumulator = (accumulator * x) + coefficients(i)
	Next
	horners_rule = accumulator
End Function

WScript.StdOut.WriteLine horners_rule(Array(-19,7,-4,6),3)
