' Align columns - RC - VBScript
	Const nr=16, nc=16
	ReDim d(nc),t(nr), wor(nr,nc)
	i=i+1: t(i) = "Given$a$text$file$of$many$lines,$where$fields$within$a$line$"
	i=i+1: t(i) = "are$delineated$by$a$single$'dollar'$character,$write$a$program"
	i=i+1: t(i) = "that$aligns$each$column$of$fields$by$ensuring$that$words$in$each$"
	i=i+1: t(i) = "column$are$separated$by$at$least$one$space."
	i=i+1: t(i) = "Further,$allow$for$each$word$in$a$column$To$be$either$left$"
	i=i+1: t(i) = "justified,$right$justified,$or$center$justified$within$its$column."
	For r=1 to nr
		If t(r)="" Then Exit For
		w=xRTrim(t(r),"$")
		m=Split(w,"$")
		For c=1 To UBound(m)+1
			wor(r,c)=m(c-1)
			If Len(wor(r,c))>d(c) Then d(c)=Len(wor(r,c))
		Next 'c
		If c>cols Then cols=c
	Next 'r
	rows=r-1
	tt=Array("Left","Right","Center")
	For n=1 To 3
		Wscript.Echo
		Wscript.Echo "*****" & tt(n-1) & "*****"
		For r=1 To rows
			w=""
			For c=1 To cols
				x=wor(r,c): s=Space(d(c))
				Select Case n
					Case 1: w=w &" "& Left   (x & s,d(c))
					Case 2: w=w &" "& Right  (s & x,d(c))
					Case 3: w=w &" "& xCentre(x,d(c)," ")
				End Select 'n
			Next 'c
			Wscript.Echo Mid(w,2)
		Next 'r
	Next 'n
	
Function xCentre(c, n, Pad)
    Dim j
    If n > Len(c) Then
		j = (n - Len(c)) \  2
		If (n - Len(c)) Mod 2 <> 0 Then j = j + 1
		xCentre = Mid(String(j, Pad) & c & String(j, Pad), 1, n)
    Else
		xCentre = c
    End If
End Function 'xCentre

Function xRTrim(c, Pad)
	Dim i2, l, cc
	cc = "": l = Len(c)
	If l > 0 Then
		i2 = l
		Do While (Mid(c, i2, 1) = Pad And i2 > 1)
			i2 = i2 - 1
		Loop
		If i2 = 1 And Mid(c, i2, 1) = Pad Then i2 = 0
		If i2 > 0 Then cc = Mid(c, 1, i2)
	End If
	xRTrim = cc
End Function 'xRTrim
