option explicit
dim a, b
wscript.stdout.write "A? "
a = wscript.stdin.readline
wscript.stdout.write "B? "
b = wscript.stdin.readline

a = int( a )
b = int( b )

wscript.echo "a + b=", a + b
wscript.echo "a - b=", a - b
wscript.echo "a * b=", a * b
wscript.echo "a / b=", a / b
wscript.echo "a \ b=", a \ b
wscript.echo "a mod b=", a mod b
wscript.echo "a ^ b=", a ^ b
