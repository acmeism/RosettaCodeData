Option Explicit
Dim a, b
Select Case WScript.Arguments.Count
	Case 0	'No arguments, prompt for them.
		WScript.Echo "Enter values for a and b"
		a = WScript.Stdin.ReadLine
		if Instr(a, " ") > 0 then	'If two variables were passed
			b = Split(a)(1)
			a = Split(a)(0)
		else
			WScript.Echo "Enter value for b"
			b = WScript.Stdin.ReadLine
		end if
	Case 1	'One argument, assume it's an input file, e.g. "in.txt"
		Dim FSO : Set FSO = CreateObject("Scripting.FileSystemObject")
		With FSO.OpenTextFile(WScript.Arguments(0), 1)
			a = .ReadLine
			b = Split(a)(1)
			a = Split(a)(0)
			.Close
		End With
	Case 2 'Two arguments, assume they are values
		a = WScript.Arguments(0)
		b = WScript.Arguments(1)
End Select
'At this point, a and b are strings as entered, make them numbers
a = CInt(a)
b = CInt(b)

'Write the sum
Wscript.Echo a + b
if 1 = WScript.Arguments.Count then
	With FSO.CreateTextFile("out.txt")
		.WriteLine a + b
		.Close
	End With
end if
