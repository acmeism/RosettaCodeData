#! /usr/bin/awk -f
BEGIN {
    # create the array, using the word as index...
    words="Zig Zag Wally Ronald Bush Krusty Charlie Bush Bozo";
    split(words, haystack_byorder, " ");
    j=0;
    for(idx in haystack_byorder) {
	haystack[haystack_byorder[idx]] = j;
	j++;
    }
    # now check for needle (we know it is there, so no "else")...
    if ( "Bush" in haystack ) {
	print "Bush is at " haystack["Bush"];
    }
    # check for unexisting needle
    if ( "Washington" in haystack ) {
	print "impossible";
    } else {
	print "Washington is not here";
    }
}
