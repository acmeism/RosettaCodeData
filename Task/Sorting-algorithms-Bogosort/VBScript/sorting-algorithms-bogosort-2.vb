dim a
a = array(11, 1, 2, 3, 4, 4, 6, 7, 8)

dim t
t = timer
while not inorder( a )
	shuffle a
wend
wscript.echo timer-t, "seconds"
wscript.echo join( a, ", " )
