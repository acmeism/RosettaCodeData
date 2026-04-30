'function arguments: "num" is the number to sequence and "return" is the value to return - "s" for the sequence or
'"e" for the number elements.
Function hailstone_sequence(num,return)
    n = num
	sequence = num
	elements = 1
	Do Until n = 1
		If n Mod 2 = 0 Then
			n = n / 2
		Else
			n = (3 * n) + 1
		End If
		sequence = sequence & " " & n
		elements = elements + 1	
	Loop
	Select Case return
		Case "s"
			hailstone_sequence = sequence
		Case "e"
			hailstone_sequence = elements
	End Select
End Function

'test driving.
'show sequence for 27
WScript.StdOut.WriteLine "Sequence for 27: " & hailstone_sequence(27,"s")
WScript.StdOut.WriteLine "Number of Elements: " & hailstone_sequence(27,"e")
WScript.StdOut.WriteBlankLines(1)
'show the number less than 100k with the longest sequence
count = 1
n_elements = 0
n_longest = ""
Do While count < 100000
	current_n_elements = hailstone_sequence(count,"e")
	If current_n_elements > n_elements Then
		n_elements = current_n_elements
		n_longest = "Number: " & count & " Length: " & n_elements
	End If
	count = count + 1
Loop
WScript.StdOut.WriteLine "Number less than 100k with the longest sequence: "
WScript.StdOut.WriteLine n_longest
