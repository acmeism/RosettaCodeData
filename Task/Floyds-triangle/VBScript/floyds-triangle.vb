' Read the number of rows to use..
intRows = WScript.StdIn.ReadLine

' Get the first number of the final row so we can calculate widths...
intLastRowStart = (intRows ^ 2 - intRows) \ 2 + 1

For i = 1 To intRows
	intLastRow = intLastRowStart
	For j = 1 To i
		k = k + 1
		WScript.StdOut.Write Space(Len(intLastRow) - Len(k)) & k & " "
		intLastRow = intLastRow + 1
	Next
	WScript.StdOut.WriteLine ""
Next
