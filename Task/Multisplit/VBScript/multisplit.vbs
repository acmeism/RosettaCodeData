Function multisplit(s,sep)
	arr_sep = Split(sep,"|")
	For i = 0 To UBound(arr_sep)
		arr_s = Split(s,arr_sep(i))
		s = Join(arr_s,",")
	Next
	multisplit = s
End Function

Function multisplit_extra(s,sep)
	Set dict_sep = CreateObject("Scripting.Dictionary")
	arr_sep = Split(sep,"|")
	For i = 0 To UBound(arr_sep)
		dict_sep.Add i,"(" & arr_sep(i) & ")"
		arr_s = Split(s,arr_sep(i))
		s = Join(arr_s,i)
	Next
	For Each key In dict_sep.Keys
		s = Replace(s,key,dict_sep.Item(key))
	Next
	multisplit_extra = s
End Function

WScript.StdOut.Write "Standard: " & multisplit("a!===b=!=c","!=|==|=")
WScript.StdOut.WriteLine
WScript.StdOut.Write "Extra Credit: " & multisplit_extra("a!===b=!=c","!=|==|=")
WScript.StdOut.WriteLine
