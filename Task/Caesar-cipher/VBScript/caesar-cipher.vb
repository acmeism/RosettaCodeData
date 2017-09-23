	str = "IT WAS THE BEST OF TIMES, IT WAS THE WORST OF TIMES."

	Wscript.Echo str
	Wscript.Echo Rotate(str,5)
	Wscript.Echo Rotate(Rotate(str,5),-5)

	'Rotate (Caesar encrypt/decrypt) test <numpos> positions.
	'  numpos < 0 - rotate left
	'  numpos > 0 - rotate right
	'Left rotation is converted to equivalent right rotation

	Function Rotate (text, numpos)

		dim dic: set dic = CreateObject("Scripting.Dictionary")
		dim ltr: ltr = Split("A B C D E F G H I J K L M N O P Q R S T U V W X Y Z")
		dim rot: rot = (26 + numpos Mod 26) Mod 26 'convert all to right rotation
		dim ch
		dim i

		for i = 0 to ubound(ltr)
			dic(ltr(i)) = ltr((rot+i) Mod 26)
		next

		Rotate = ""

		for i = 1 to Len(text)
			ch = Mid(text,i,1)
			if dic.Exists(ch) Then
				Rotate = Rotate & dic(ch)
			else
				Rotate = Rotate & ch
			end if
		next

	End Function
