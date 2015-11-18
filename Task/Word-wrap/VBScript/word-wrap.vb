column = 60
text = "In olden times when wishing still helped one, there lived a king " &_
	"whose daughters were all beautiful, but the youngest was so beautiful "&_
	"that the sun itself, which has seen so much, was astonished whenever "&_
	"it shone-in-her-face.  Close-by-the-king's castle lay a great dark "&_
	"forest, and under an old lime-tree in the forest was a well, and when "&_
	"the day was very warm, the king's child went out into the forest and "&_
	"sat down by the side of the cool-fountain, and when she was bored she "&_
	"took a golden ball, and threw it up on high and caught it, and this "&_
	"ball was her favorite plaything."

Call wordwrap(text,column)

Sub wordwrap(s,n)
	word = Split(s," ")
	row = ""
	For i = 0 To UBound(word)
		If Len(row) = 0 Then
			row = row & word(i)
		ElseIf Len(row & " " & word(i)) <= n Then
			row = row & " " & word(i)
		Else
			WScript.StdOut.WriteLine row
			row = word(i)
		End If
	Next
	If Len(row) > 0 Then
		WScript.StdOut.WriteLine row
	End If
End Sub
