dim a
a = array( 1,2,3,4,5,6,7,8,9)
wscript.echo "before: ", join( a, ", " )
shuffle a
wscript.echo "after: ", join( a, ", " )
shuffle a
wscript.echo "after: ", join( a, ", " )
wscript.echo "--"
a = array( now(), "cow", 123, true, sin(1), 16.4 )
wscript.echo "before: ", join( a, ", " )
shuffle a
wscript.echo "after: ", join( a, ", " )
shuffle a
wscript.echo "after: ", join( a, ", " )
