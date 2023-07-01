option explicit

function eef( b, r1, r2 )
	if b then
		eef = r1
	else
		eef = r2
	end if
end function

dim a, b
wscript.stdout.write "First integer: "
a = cint(wscript.stdin.readline) 'force to integer

wscript.stdout.write "Second integer: "
b = cint(wscript.stdin.readline) 'force to integer

wscript.stdout.write "First integer is "
if a < b then wscript.stdout.write "less than "
if a = b then wscript.stdout.write "equal to "
if a > b then wscript.stdout.write "greater than "
wscript.echo "Second integer."

wscript.stdout.write "First integer is " & _
    eef( a < b, "less than ", _
    eef( a = b, "equal to ", _
    eef( a > b, "greater than ", vbnullstring ) ) ) & "Second integer."
