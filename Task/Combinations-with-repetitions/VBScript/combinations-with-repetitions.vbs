' Combinations with repetitions - iterative - VBScript

Sub printc(vi,n,vs)
	Dim i, w
	For i=0 To n-1
		w=w &" "& vs(vi(i))
	Next 'i
	Wscript.Echo w
End Sub

Sub combine(flavors, draws, xitem, tell)
	Dim n, i, j
	ReDim v(draws)
	If tell Then Wscript.Echo "list of cwr("& flavors &","& draws &") :"
	Do While True
		For i=0 To draws-1
			If v(i)>flavors-1 Then
				v(i+1)=v(i+1)+1
				For j=i To 0 Step -1
					v(j)=v(i+1)
				Next 'j
			End If
		Next 'i
		If v(draws)>0 Then Exit Do
		n=n+1
		If tell Then Call printc(v, draws, xitem)
		v(0)=v(0)+1
	Loop
	Wscript.Echo "cwr("& flavors &","& draws &")="&n
End Sub

	items=Array( "iced", "jam", "plain" )
	combine  3, 2, items, True
	combine 10, 3, ,      False
	combine 10, 7, ,      False
	combine 10, 9, ,      False
