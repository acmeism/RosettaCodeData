Function agm(a,g)
	Do Until a = tmp_a
		tmp_a = a
		a = (a + g)/2
		g = Sqr(tmp_a * g)
	Loop
	agm = a
End Function

WScript.Echo agm(1,1/Sqr(2))
