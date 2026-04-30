Function JortSort(s)
	JortSort = True
	arrPreSort = Split(s,",")
	Set arrSorted = CreateObject("System.Collections.ArrayList")
	'Populate the resorted arraylist.
	For i = 0 To UBound(arrPreSort)
		arrSorted.Add(arrPreSort(i))
	Next
	arrSorted.Sort()
	'Compare the elements of both arrays.
	For j = 0 To UBound(arrPreSort)
		If arrPreSort(j) <> arrSorted(j) Then
			JortSort = False
			Exit For
		End If
	Next
End Function

WScript.StdOut.Write JortSort("1,2,3,4,5")
WScript.StdOut.WriteLine
WScript.StdOut.Write JortSort("1,2,3,5,4")
WScript.StdOut.WriteLine
WScript.StdOut.Write JortSort("a,b,c")
WScript.StdOut.WriteLine
WScript.StdOut.Write JortSort("a,c,b")
