# syntax: GAWK -f 4-RINGS_OR_4-SQUARES_PUZZLE.AWK
# converted from C
BEGIN {
    cmd = "SORT /+16"
    four_squares(1,7,1,1)
    four_squares(3,9,1,1)
    four_squares(0,9,0,0)
    four_squares(0,6,1,0)
    four_squares(2,8,1,0)
    exit(0)
}
function four_squares(plo,phi,punique,pshow) {
    lo = plo
    hi = phi
    unique = punique
    show = pshow
    solutions = 0
    print("")
    if (show) {
      print("A B C D E F G  sum  A+B B+C+D D+E+F F+G")
      print("-------------  ---  -------------------")
    }
    acd()
    close(cmd)
    tmp = (unique) ? "unique" : "non-unique"
    printf("%d-%d: %d %s solutions\n",lo,hi,solutions,tmp)
}
function acd() {
    for (c=lo; c<=hi; c++) {
      for (d=lo; d<=hi; d++) {
        if (!unique || c != d) {
          a = c + d
          if (a >= lo && a <= hi && (!unique || (c != 0 && d != 0))) {
            ge()
          }
        }
      }
    }
}
function bf() {
    for (f=lo; f<=hi; f++) {
      if (!unique || (f != a && f != c && f != d && f != g && f != e)) {
        b = e + f - c
        if (b >= lo && b <= hi && (!unique || (b != a && b != c && b != d && b != g && b != e && b != f))) {
          solutions++
          if (show) {
            printf("%d %d %d %d %d %d %d %4d  ",a,b,c,d,e,f,g,a+b) | cmd
            printf("%d+%d ",a,b) | cmd
            printf("%d+%d+%d ",b,c,d) | cmd
            printf("%d+%d+%d ",d,e,f) | cmd
            printf("%d+%d\n",f,g) | cmd
          }
        }
      }
    }
}
function ge() {
    for (e=lo; e<=hi; e++) {
      if (!unique || (e != a && e != c && e != d)) {
        g = d + e
        if (g >= lo && g <= hi && (!unique || (g != a && g != c && g != d && g != e))) {
          bf()
        }
      }
    }
}
