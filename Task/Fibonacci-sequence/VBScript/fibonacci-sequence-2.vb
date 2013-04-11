dim fib
set fib = new generator
dim i
for i = 1 to 100
	wscript.stdout.write " " & fib
	if fib.overflow then
		wscript.echo
		exit for
	end if
next
