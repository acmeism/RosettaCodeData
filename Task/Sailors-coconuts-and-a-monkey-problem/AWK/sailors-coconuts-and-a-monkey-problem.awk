# syntax: GAWK -f SAILORS_COCONUTS_AND_A_MONKEY_PROBLEM.AWK
# converted from LUA
BEGIN {
    for (n=2; n<=9; n++) {
      x = 0
      while (!valid(n,x)) {
        x++
      }
      printf("%d %d\n",n,x)
    }
    exit(0)
}
function valid(n,nuts,  k) {
    k = n
    while (k != 0) {
      if ((nuts % n) != 1) {
        return(0)
      }
      k--
      nuts = nuts - 1 - int(nuts / n)
    }
    return((nuts != 0) && (nuts % n == 0))
}
