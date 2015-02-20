# usage: awk -f pangram.awk -v p="The five boxing wizards dump quickly." input.txt
#
# Pangram-checker, using associative arrays and split
BEGIN {
  alfa="ABCDEFGHIJKLMNOPQRSTUVWXYZ"; ac=split(alfa,A,"")
  print "# Checking for all",ac,"chars in '" alfa "' :"

  print testPangram("The quick brown fox jumps over the lazy dog.");
  print testPangram(p);
}

{ print testPangram($0) }

function testPangram(str,   c,i,S,H,hit,miss) {
    print str  						##
    split( toupper(str), S, "")
    for (c in S) {
      H[ S[c] ]++
     #print c, S[c], H[ S[c] ]				##
    }
    for (i=1; i<=ac; i++) {
      c = A[i]
     #printf("%2d %c : %4d\n", i, c, H[c] )  		##
      if (H[c]) { hit=hit c } else { miss=miss c }
    }
    print "# hit:",hit, "# miss:",miss, "."		##
    if (miss) return 0
    return 1
}
