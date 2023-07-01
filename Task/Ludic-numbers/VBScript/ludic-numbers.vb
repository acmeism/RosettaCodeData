Set list = CreateObject("System.Collections.Arraylist")
Set ludic = CreateObject("System.Collections.Arraylist")

'populate the list
For i = 1 To 25000
	list.Add i
Next

'set 1 as the first ludic number
ludic.Add list(0)
list.RemoveAt(0)

'variable to count ludic numbers <= 1000
up_to_1k = 1

'determine the succeeding ludic numbers
For j = 2 To 2005
	If list.Count > 0 Then
		If list(0) <= 1000 Then
			up_to_1k = up_to_1k + 1
		End If
		ludic.Add list(0)
	Else
		Exit For
	End If
	increment = list(0) - 1
	n = 0
	Do While n <= list.Count - 1
		list.RemoveAt(n)
		n = n + increment
	Loop
Next

'the first 25 ludics
WScript.StdOut.WriteLine "First 25 Ludic Numbers:"
For k = 0 To 24
	If k < 24 Then
		WScript.StdOut.Write ludic(k) & ", "
	Else
		WScript.StdOut.Write ludic(k)
	End If
Next
WScript.StdOut.WriteBlankLines(2)

'the number of ludics up to 1000
WScript.StdOut.WriteLine "Ludics up to 1000: "
WScript.StdOut.WriteLine up_to_1k
WScript.StdOut.WriteBlankLines(1)

'2000th - 2005th ludics
WScript.StdOut.WriteLine "The 2000th - 2005th Ludic Numbers:"
For k = 1999 To 2004
	If k < 2004 Then
		WScript.StdOut.Write ludic(k) & ", "
	Else
		WScript.StdOut.Write ludic(k)
	End If
Next
WScript.StdOut.WriteBlankLines(2)

'triplets up to 250: x, x+2, and x+6
WScript.StdOut.WriteLine "Ludic Triplets up to 250: "
triplets = ""
k = 0
Do While ludic(k) + 6 <= 250
	x2 = ludic(k) + 2
	x6 = ludic(k) + 6
	If ludic.IndexOf(x2,1) > 0 And ludic.IndexOf(x6,1) > 0 Then
		triplets = triplets & ludic(k) & ", " & x2 & ", " & x6 & vbCrLf
	End If
	k = k + 1
Loop
WScript.StdOut.WriteLine triplets
