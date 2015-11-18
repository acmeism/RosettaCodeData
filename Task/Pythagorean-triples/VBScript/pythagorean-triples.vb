For i=1 To 8
	WScript.StdOut.WriteLine triples(10^i)
Next

Function triples(pmax)
	prim=0 : count=0 : nmax=Sqr(pmax)/2 : n=1
	Do While n <= nmax
		m=n+1 : p=2*m*(m+n)
		Do While p <= pmax
			If gcd(m,n)=1 Then
				prim=prim+1
				count=count+Int(pmax/p)
			End If
			m=m+2
			p=2*m*(m+n)
		Loop
		n=n+1
	Loop
	triples = "Max Perimeter: " & pmax &_
				", Total: " & count &_
				", Primitive: " & prim
End Function

Function gcd(a,b)
	c = a : d = b
	Do
		If c Mod d > 0 Then
			e = c Mod d
			c = d
			d = e
		Else
			gcd = d
			Exit Do
		End If
	Loop
End Function
