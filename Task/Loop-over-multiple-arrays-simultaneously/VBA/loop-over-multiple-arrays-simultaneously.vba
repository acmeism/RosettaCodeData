' Loop over multiple arrays simultaneously - VBA - 08/02/2021

Sub Main()
	a = Array("a","b","c")
	b = Array("A","B","C")
	c = Array(1,2,3)
	For i = LBound(a) To UBound(a)
		buf = buf & vbCrLf & a(i) & b(i) & c(i)
	Next
	Debug.Print Mid(buf,3)
End Sub
