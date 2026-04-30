Function mtf_encode(s)
	'create the array list and populate it with the initial symbol position
	Set symbol_table = CreateObject("System.Collections.ArrayList")
	For j = 97 To 122 'a to z in decimal.
		symbol_table.Add Chr(j)
	Next
	output = ""
	For i = 1 To Len(s)
		char = Mid(s,i,1)
		If i = Len(s) Then
			output = output & symbol_table.IndexOf(char,0)
			symbol_table.RemoveAt(symbol_table.LastIndexOf(char))
			symbol_table.Insert 0,char
		Else
			output = output & symbol_table.IndexOf(char,0) & " "
			symbol_table.RemoveAt(symbol_table.LastIndexOf(char))
			symbol_table.Insert 0,char
		End If
	Next
	mtf_encode = output
End Function

Function mtf_decode(s)
	'break the function argument into an array
	code = Split(s," ")
	'create the array list and populate it with the initial symbol position
	Set symbol_table = CreateObject("System.Collections.ArrayList")
	For j = 97 To 122 'a to z in decimal.
		symbol_table.Add Chr(j)
	Next
	output = ""
	For i = 0 To UBound(code)
		char = symbol_table(code(i))
		output = output & char
		If code(i) <> 0 Then
			symbol_table.RemoveAt(symbol_table.LastIndexOf(char))
			symbol_table.Insert 0,char
		End If
	Next
	mtf_decode = output	
End Function

'Testing the functions
wordlist = Array("broood","bananaaa","hiphophiphop")
For Each word In wordlist
	WScript.StdOut.Write word & " encodes as " & mtf_encode(word) & " and decodes as " &_
		mtf_decode(mtf_encode(word)) & "."
	WScript.StdOut.WriteBlankLines(1)
Next
