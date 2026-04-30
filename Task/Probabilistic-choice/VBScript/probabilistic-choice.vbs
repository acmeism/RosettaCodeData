item = Array("aleph","beth","gimel","daleth","he","waw","zayin","heth")
prob = Array(1/5.0, 1/6.0, 1/7.0, 1/8.0, 1/9.0, 1/10.0, 1/11.0, 1759/27720)
Dim cnt(7)

'Terminate script if sum of probabilities <> 1.
sum = 0
For i = 0 To UBound(prob)
	sum = sum + prob(i)
Next

If sum <> 1 Then
	WScript.Quit
End If

For trial = 1 To 1000000
	r = Rnd(1)
	p = 0
	For i = 0 To UBound(prob)
		p = p + prob(i)
		If r < p Then
			cnt(i) = cnt(i) + 1
			Exit For
		End If
	Next
Next

WScript.StdOut.Write "item" & vbTab & "actual" & vbTab & vbTab & "theoretical"
WScript.StdOut.WriteLine
For i = 0 To UBound(item)
	WScript.StdOut.Write item(i) & vbTab & FormatNumber(cnt(i)/1000000,6) & vbTab & FormatNumber(prob(i),6)
	WScript.StdOut.WriteLine
Next
