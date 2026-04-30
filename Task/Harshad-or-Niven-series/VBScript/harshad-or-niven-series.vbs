n = 0
m = 1
first20 = ""
after1k = ""

Do
	If IsHarshad(m) And n <= 20 Then
		first20 = first20 & m & ", "
		n = n + 1
		m = m + 1
	ElseIf IsHarshad(m) And m > 1000 Then
		after1k = m
		Exit Do
	Else
		m = m + 1
	End If
Loop

WScript.StdOut.Write "First twenty Harshad numbers are: "
WScript.StdOut.WriteLine
WScript.StdOut.Write first20
WScript.StdOut.WriteLine
WScript.StdOut.Write "The first Harshad number after 1000 is: "
WScript.StdOut.WriteLine
WScript.StdOut.Write after1k

Function IsHarshad(s)
	IsHarshad = False
	sum = 0
	For i = 1 To Len(s)
		sum = sum + CInt(Mid(s,i,1))
	Next
	If s Mod sum = 0 Then
		IsHarshad = True
	End If
End Function
