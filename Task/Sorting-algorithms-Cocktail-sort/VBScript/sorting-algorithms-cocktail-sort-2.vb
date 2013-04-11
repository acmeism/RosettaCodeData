dim a
a = array( "portcullis", "redoubt", "palissade", "turret", "collins", "the parapet", "the quarterdeck")
wscript.echo join( a, ", ")

dim b
b = cocktailSort( a )
wscript.echo join( b, ", ")
