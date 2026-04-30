Function remove_duplicates(list)
	arr = Split(list,",")
	Set dict = CreateObject("Scripting.Dictionary")
	For i = 0 To UBound(arr)
		If dict.Exists(arr(i)) = False Then
			dict.Add arr(i),""
		End If
	Next
	For Each key In dict.Keys
		tmp = tmp & key & ","
	Next
	remove_duplicates = Left(tmp,Len(tmp)-1)
End Function

WScript.Echo remove_duplicates("a,a,b,b,c,d,e,d,f,f,f,g,h")
