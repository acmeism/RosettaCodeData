'http://rosettacode.org/wiki/Van_der_Corput_sequence
'Van der Corput Sequence fucntion call = VanVanDerCorput(number,base)

Base2 = "0" : Base3 = "0" : Base4 = "0" : Base5 = "0"
Base6 = "0" : Base7 = "0" : Base8 = "0" : Base9 = "0"

l = 1
h = 1
Do Until l = 9
	'Set h to the value of l after each function call
	'as it sets it to 0 - see lines 37 to 40.
	Base2 = Base2 & ", " & VanDerCorput(h,2) : h = l
	Base3 = Base3 & ", " & VanDerCorput(h,3) : h = l
	Base4 = Base4 & ", " & VanDerCorput(h,4) : h = l
	Base5 = Base5 & ", " & VanDerCorput(h,5) : h = l
	Base6 = Base6 & ", " & VanDerCorput(h,6) : h = l
	l = l + 1
Loop

WScript.Echo "Base 2: " & Base2
WScript.Echo "Base 3: " & Base3
WScript.Echo "Base 4: " & Base4
WScript.Echo "Base 5: " & Base5
WScript.Echo "Base 6: " & Base6

'Van der Corput Sequence
Function VanDerCorput(n,b)
	k = RevString(Dec2BaseN(n,b))
	For i = 1 To Len(k)
		VanDerCorput = VanDerCorput + (CLng(Mid(k,i,1)) * b^-i)
	Next
End Function

'Decimal to Base N Conversion
Function Dec2BaseN(q,c)
	Dec2BaseN = ""
	Do Until q = 0
		Dec2BaseN = CStr(q Mod c) & Dec2BaseN
		q = Int(q / c)
	Loop
End Function

'Reverse String
Function RevString(s)
	For j = Len(s) To 1 Step -1
		RevString = RevString & Mid(s,j,1)
	Next
End Function
