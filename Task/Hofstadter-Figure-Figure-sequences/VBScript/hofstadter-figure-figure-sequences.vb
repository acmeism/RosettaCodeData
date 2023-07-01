'Initialize the r and the s arrays.
Set r = CreateObject("System.Collections.ArrayList")
Set s = CreateObject("System.Collections.ArrayList")

'Set initial values of r.
r.Add ""  : r.Add 1

'Set initial values of s.
s.Add "" : s.Add 2

'Populate the r and the s arrays.
For i = 2 To 1000
	ffr(i)
	ffs(i)
Next

'r function
Function ffr(n)
	r.Add r(n-1)+s(n-1)
End Function

's function
Function ffs(n)
	'index is the value of the last element of the s array.
	index = s(n-1)+1
	Do
                'Add to s if the current index is not in the r array.
		If r.IndexOf(index,0) = -1 Then
			s.Add index
			Exit Do
		Else
			index = index + 1
		End If
	Loop
End Function

'Display the first 10 values of r.
WScript.StdOut.Write "First 10 Values of R:"
WScript.StdOut.WriteLine
For j = 1 To 10
	If j = 10 Then
		WScript.StdOut.Write "and " & r(j)
	Else
		WScript.StdOut.Write r(j) & ", "
	End If
Next
WScript.StdOut.WriteBlankLines(2)

'Show that the first 40 values of r plus the first 960 values of s include all the integers from 1 to 1000 exactly once.
'The idea here is to create another array(integer) with 1000 elements valuing from 1 to 1000. Go through the first 40 values
'of the r array and remove the corresponding element in the integer array.  Do the same thing with the first 960 values of
'the s array.  If the resultant count of the integer array is 0 then it is a pass.
Set integers = CreateObject("System.Collections.ArrayList")
For k = 1 To 1000
	integers.Add k
Next
For l = 1 To 960
	If l <= 40 Then
		integers.Remove(r(l))
	End If
	integers.Remove(s(l))
Next
WScript.StdOut.Write "Test for the first 1000 integers: "
If integers.Count = 0 Then
	WScript.StdOut.Write "Passed!!!"
	WScript.StdOut.WriteLine
Else
	WScript.StdOut.Write "Miserably Failed!!!"
	WScript.StdOut.WriteLine
End If
