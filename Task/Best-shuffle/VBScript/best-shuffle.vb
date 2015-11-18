Function shuffle(s)
	Dim arr()
	ReDim arr(Len(s)-1)
	Set objrandom = CreateObject("System.Random")
	For i = 1 To Len(s)
		l = Mid(s,i,1)
		Do
			n = objrandom.Next_2(0,Len(s))
			If arr(n) = "" Then
				arr(n) = l
				Exit Do
			End If
		Loop	
	Next
	shuffled_word = Join(arr,"")
	score = 0
	For j = 1 To Len(s)
		If Mid(s,j,1) = Mid(shuffled_word,j,1) Then
			score = score + 1
		End If
	Next
	shuffle = shuffled_word & ",(" & score & ")"
End Function

'Testing the function
word_list = Array("abracadabra","seesaw","elk","grrrrrr","up","a")
For Each word In word_list
	WScript.StdOut.WriteLine word & "," & shuffle(word)
Next
