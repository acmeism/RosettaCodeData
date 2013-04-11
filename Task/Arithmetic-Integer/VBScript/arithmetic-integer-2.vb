option explicit
dim a, b
wscript.stdout.write "A? "
a = wscript.stdin.readline
wscript.stdout.write "B? "
b = wscript.stdin.readline

a = int( a )
b = int( b )

dim op
for each op in split("+ - * / \ mod ^", " ")
	wscript.echo "a",op,"b=",eval( "a " & op & " b")
next
