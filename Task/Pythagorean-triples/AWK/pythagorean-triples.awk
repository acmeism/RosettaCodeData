# syntax: GAWK -f PYTHAGOREAN_TRIPLES.AWK
# converted from Go
BEGIN {
    printf("%5s %11s %11s %11s %s\n","limit","limit","triples","primitives","seconds")
    for (max_peri=10; max_peri<=1E9; max_peri*=10) {
      t = systime()
      prim = 0
      total = 0
      new_tri(3,4,5)
      printf("10^%-2d %11d %11d %11d %d\n",++n,max_peri,total,prim,systime()-t)
    }
    exit(0)
}
function new_tri(s0,s1,s2,  p) {
    p = s0 + s1 + s2
    if (p <= max_peri) {
      prim++
      total += int(max_peri / p)
      new_tri(+1*s0-2*s1+2*s2,+2*s0-1*s1+2*s2,+2*s0-2*s1+3*s2)
      new_tri(+1*s0+2*s1+2*s2,+2*s0+1*s1+2*s2,+2*s0+2*s1+3*s2)
      new_tri(-1*s0+2*s1+2*s2,-2*s0+1*s1+2*s2,-2*s0+2*s1+3*s2)
    }
}
