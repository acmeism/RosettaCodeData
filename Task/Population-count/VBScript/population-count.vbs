' Population count - VBScript - 10/05/2019
	nmax=30
	b=3
	n=0: list="": bb=1
	For i=0 To nmax-1
		list=list & " " & popcount(bb)
		bb=bb*b
	Next 'i
	Msgbox list,,"popcounts of the powers of " & b
	For j=0 to 1
		If j=0 Then c="evil numbers": Else c="odious numbers"
		n=0: list="": i=0
		While n<nmax
			If (popcount(i) Mod 2)=j Then
				n=n+1
				list=list & " " & i
			End If
			i=i+1
		Wend
		Msgbox list,,c
	Next 'j

Function popcount(x)
	Dim y,xx,xq,xr
	xx=x
	While xx>0
		xq=Int(xx/2)
		xr=xx-xq*2
		If xr=1 Then y=y+1
		xx=xq
	Wend
	popcount=y
End Function 'popcount
