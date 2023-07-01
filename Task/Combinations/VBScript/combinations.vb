Function Dec2Bin(n)
	q = n
	Dec2Bin = ""
	Do Until q = 0
		Dec2Bin = CStr(q Mod 2) & Dec2Bin
		q = Int(q / 2)
	Loop
	Dec2Bin = Right("00000" & Dec2Bin,6)
End Function

Sub Combination(n,k)
	Dim arr()
	ReDim arr(n-1)
	For h = 0 To n-1
		arr(h) = h + 1
	Next
	Set list = CreateObject("System.Collections.Arraylist")
	For i = 1 To 2^n
		bin = Dec2Bin(i)
		c = 0
		tmp_combo = ""
		If Len(Replace(bin,"0","")) = k Then
			For j = Len(bin) To 1 Step -1
				If CInt(Mid(bin,j,1)) = 1 Then
					tmp_combo = tmp_combo & arr(c) & ","
				End If
				c = c + 1
			Next
			list.Add Mid(tmp_combo,1,(k*2)-1)
		End If
	Next
	list.Sort
	For l = 0 To list.Count-1
		WScript.StdOut.Write list(l)
		WScript.StdOut.WriteLine
	Next
End Sub

'Testing with n = 5 / k = 3
Call Combination(5,3)
