dim a1
dim cb
set cb = new callback

cb.rule = "ucase(p1)"
a1 = split("my dog has fleas", " " )
cb.applyTo a1
wscript.echo join( a1, " " )

cb.rule = "p1 ^ p1"
a1 = array(1,2,3,4,5,6,7,8,9,10)
cb.applyto a1
wscript.echo join( a1, ", " )
