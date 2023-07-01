'Binary Integer overflow - vbs
i=(-2147483647-1)/-1
wscript.echo i
i0=32767 	    '=32767      Integer (Fixed)  type=2
i1=2147483647	    '=2147483647 Long    (Fixed)  type=3
i2=-(-2147483647-1) '=2147483648 Double  (Float)  type=5
wscript.echo Cstr(i0) & " : " & typename(i0) & " , " & vartype(i0) & vbcrlf _
           & Cstr(i1) & " : " & typename(i1) & " , " & vartype(i1) & vbcrlf _
           & Cstr(i2) & " : " & typename(i2) & " , " & vartype(i2)
ii=2147483648-2147483647
if vartype(ii)<>3 or vartype(ii)<>2 then wscript.echo "Integer overflow type=" & typename(ii)
i1=1000000000000000-1 '1E+15-1
i2=i1+1               '1E+15
wscript.echo Cstr(i1) & " , " & Cstr(i2)
