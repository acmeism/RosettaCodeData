# syntax: GAWK -f EXPONENTIATION_WITH_INFIX_OPERATORS_IN_OR_OPERATING_ON_THE_BASE.AWK
# converted from FreeBASIC
BEGIN {
    print("  x   p |     -x^p   -(x)^p   (-x)^p   -(x^p)")
    print("--------+------------------------------------")
    for (x=-5; x<=5; x+=10) {
      for (p=2; p<=3; p++) {
        printf("%3d %3d | %8d %8d %8d %8d\n",x,p,(-x^p),(-(x)^p),((-x)^p),(-(x^p)))
      }
    }
    exit(0)
}
