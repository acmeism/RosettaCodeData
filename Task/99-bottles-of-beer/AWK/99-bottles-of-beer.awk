# usage:  gawk  -v i=6  -f beersong.awk

function bb(n) {
	b = " bottles of beer"
	if( n==1 ) { sub("s","",b) }
	if( n==0 ) { n="No more" }
	return n b
}

BEGIN {
	if( !i ) { i = 99 }
	ow = "on the wall"
	td = "Take one down, pass it around."
	print "The beersong:\n"
	while (i > 0) {
		printf( "%s %s,\n%s.\n%s\n%s %s.\n\n",
			bb(i), ow, bb(i), td, bb(--i), ow )
		if( i==1 ) sub( "one","it", td )
	}
	print "Go to the store and buy some more!"
}
