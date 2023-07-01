# syntax: GAWK -f POPULATION_COUNT.AWK
# converted from VBSCRIPT
BEGIN {
    nmax = 30
    b = 3
    n = 0
    bb = 1
    for (i=1; i<=nmax; i++) {
      list = list pop_count(bb) " "
      bb *= b
    }
    printf("%s^n: %s\n",b,list)
    for (j=0; j<=1; j++) {
      c = (j == 0) ? "evil" : "odious"
      i = n = 0
      list = ""
      while (n < nmax) {
        if (pop_count(i) % 2 == j) {
          n++
          list = list i " "
        }
        i++
      }
      printf("%s: %s\n",c,list)
    }
    exit(0)
}
function pop_count(xx,  xq,xr,y) {
    while (xx > 0) {
      xq = int(xx / 2)
      xr = xx - xq * 2
      if (xr == 1) { y++ }
      xx = xq
    }
    return(y)
}
