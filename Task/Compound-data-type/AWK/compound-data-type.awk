BEGIN {
	p["x"]=10
	p["y"]=42

	z = "ZZ"
	p[ z ]=999

	p[ 4 ]=5
	
	for (i in p) print( i, ":", p[i] )
}
