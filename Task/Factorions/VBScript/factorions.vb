' Factorions - VBScript - PG - 26/04/2020
    Dim fact()
	nn1=9 : nn2=12
	lim=1499999
    ReDim fact(nn2)
	fact(0)=1
	For i=1 To nn2
		fact(i)=fact(i-1)*i
	Next
	For base=nn1 To nn2
		list=""
		For i=1 To lim
			s=0
			t=i
			Do While t<>0
				d=t Mod base
				s=s+fact(d)
				t=t\base
			Loop
			If s=i Then list=list &" "& i
		Next
		Wscript.Echo "the factorions for base "& right(" "& base,2) &" are: "& list
	Next
