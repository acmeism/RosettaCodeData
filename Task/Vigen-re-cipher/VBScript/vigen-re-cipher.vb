Function Encrypt(text,key)
	text = OnlyCaps(text)
	key = OnlyCaps(key)
	j = 1
	For i = 1 To Len(text)
		ms = Mid(text,i,1)
		m = Asc(ms) - Asc("A")
		ks = Mid(key,j,1)
		k = Asc(ks) - Asc("A")
		j = (j Mod Len(key)) + 1
		c = (m + k) Mod 26
		c = Chr(Asc("A")+c)
		Encrypt = Encrypt & c
	Next
End Function

Function Decrypt(text,key)
	key = OnlyCaps(key)
	j = 1
	For i = 1 To Len(text)
		ms = Mid(text,i,1)
		m = Asc(ms) - Asc("A")
		ks = Mid(key,j,1)
		k = Asc(ks) - Asc("A")
		j = (j Mod Len(key)) + 1
		c = (m - k + 26) Mod 26
		c = Chr(Asc("A")+c)
		Decrypt = Decrypt & c
	Next
End Function

Function OnlyCaps(s)
	For i = 1 To Len(s)
		char = UCase(Mid(s,i,1))
		If Asc(char) >= 65 And Asc(char) <= 90 Then
			OnlyCaps = OnlyCaps & char
		End If
	Next
End Function

'testing the functions
orig_text = "Beware the Jabberwock, my son! The jaws that bite, the claws that catch!"
orig_key = "vigenerecipher"
WScript.StdOut.WriteLine "Original: " & orig_text
WScript.StdOut.WriteLine "Key: " & orig_key
WScript.StdOut.WriteLine "Encrypted: " & Encrypt(orig_text,orig_key)
WScript.StdOut.WriteLine "Decrypted: " & Decrypt(Encrypt(orig_text,orig_key),orig_key)
