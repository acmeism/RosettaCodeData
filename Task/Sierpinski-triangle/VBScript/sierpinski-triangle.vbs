Sub triangle(o)
	n = 2 ^ o
	Dim line()
	ReDim line(2*n)
	line(n) = "*"
	i = 0
	Do While i < n
		WScript.StdOut.WriteLine Join(line,"")
		u = "*"
		j = n - i
		Do While j < (n+i+1)
			If line(j-1) = line(j+1) Then
				t = " "
			Else
				t = "*"
			End If
			line(j-1) = u
			u = t
			j = j + 1
		Loop
		line(n+i) = t
		line(n+i+1) = "*"
		i = i + 1
	Loop
End Sub

triangle(4)
