dim a
dim b

a = array( "zanzibar", "aardvark","ampicillin","zulu","gogodala", "wolverhampton")
b = gnomeSort( a )
wscript.echo join(a, ", ")

a = array( 234,567,345,568,2345,89,547,23,649,5769,456,456,567)
b = gnomeSort( a )
wscript.echo join(a, ", ")

a = array( true, false, true, true, false, false, true, false)
b = gnomeSort( a )
wscript.echo join(a, ", ")

a = array( 1,2,2,4,67789,-3,-45.99)
b = gnomeSort( a )
wscript.echo join(a, ", ")

a = array( now(), now()-1,now()+2)
b = gnomeSort( a )
wscript.echo join(a, ", ")
