Phrase = "rosetta code phrase reversal"

WScript.StdOut.Write "Original String          : " & Phrase
WScript.StdOut.WriteLine
WScript.StdOut.Write "Reverse String           : " & RevString(Phrase)
WScript.StdOut.WriteLine
WScript.StdOut.Write "Reverse String Each Word : " & RevStringEachWord(Phrase)
WScript.StdOut.WriteLine
WScript.StdOut.Write "Reverse Phrase           : " & RevPhrase(Phrase)
WScript.StdOut.WriteLine

Function RevString(s)
	x = Len(s)
	For i = 1 To Len(s)
		RevString = RevString & Mid(s,x,1)
		x = x - 1
	Next
End Function

Function RevStringEachWord(s)
	arr = Split(s," ")
	For i = 0 To UBound(arr)
		RevStringEachWord = RevStringEachWord & RevString(arr(i))
		If i < UBound(arr) Then
			RevStringEachWord = RevStringEachWord & " "
		End If
	Next
End Function

Function RevPhrase(s)
	arr = Split(s," ")
	For i = UBound(arr) To LBound(arr) Step -1
		RevPhrase = RevPhrase & arr(i)
		If i > LBound(arr) Then
			RevPhrase = RevPhrase & " "
		End If
	Next
End Function
