data = "foo,bar,baz,quux,quuux,quuuux,bazola,ztesch,foo,bar,thud,grunt," &_
		"foo,bar,bletch,foo,bar,fum,fred,jim,sheila,barney,flarp,zxc," &_
		"spqr,wombat,shme,foo,bar,baz,bongo,spam,eggs,snork,foo,bar," &_
		"zot,blarg,wibble,toto,titi,tata,tutu,pippo,pluto,paperino,aap," &_
		"noot,mies,oogle,foogle,boogle,zork,gork,bork"

haystack = Split(data,",")

Do
	WScript.StdOut.Write "Word to search for? (Leave blank to exit) "
	needle = WScript.StdIn.ReadLine
	If needle <> "" Then
		found = 0
		For i = 0 To UBound(haystack)
			If UCase(haystack(i)) = UCase(needle) Then
				found = 1
				WScript.StdOut.Write "Found " & Chr(34) & needle & Chr(34) & " at index " & i
				WScript.StdOut.WriteLine
			End If
		Next
		If found < 1 Then
			WScript.StdOut.Write Chr(34) & needle & Chr(34) & " not found."
			WScript.StdOut.WriteLine
		End If
	Else
		Exit do
	End If
Loop
