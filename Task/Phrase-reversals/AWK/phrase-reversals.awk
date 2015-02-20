# Usage:  awk -f phrase_revers.awk
function rev(s, del,   n,i,a,r) {
   n = split(s, a, del)
   r = a[1]
   for(i=2; i <= n; i++) {r = a[i] del r }
   return r
}

BEGIN {
  p0 = "Rosetta Code Phrase Reversal"

  fmt = "%-20s: %s\n"
  printf( fmt, "input",               p0 )
  printf( fmt, "string reversed",     rev(p0, "") )
  wr = rev(p0, " ")
  printf( fmt, "word-order reversed", wr )
  printf( fmt, "each word reversed",  rev(wr) )
}
