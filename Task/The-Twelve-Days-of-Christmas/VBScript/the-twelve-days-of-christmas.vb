days = Array("first","second","third","fourth","fifth","sixth",_
		"seventh","eight","ninth","tenth","eleventh","twelfth")
		
gifts = Array("A partridge in a pear tree","Two turtle doves","Three french hens",_
	"Four calling birds","Five golden rings","Six geese a-laying","Seven swans a-swimming",_
	"Eight maids a-milking","Nine ladies dancing","Ten lords a-leaping","Eleven pipers piping",_
	"Twelve drummers drumming")
	
For i = 0 To 11
	WScript.StdOut.Write "On the " & days(i) & " day of Christmas"
	WScript.StdOut.WriteLine
	WScript.StdOut.Write "My true love sent to me:"
	WScript.StdOut.WriteLine
	If i = 0 Then
		WScript.StdOut.Write gifts(i)
	Else
		For j = i To 0 Step - 1
			If j = 0 Then
				WScript.StdOut.Write "and " & gifts(0)
			Else
				WScript.StdOut.Write gifts(j)
				WScript.StdOut.WriteLine
			End If
		Next
	End If
		WScript.StdOut.WriteBlankLines(2)
Next
