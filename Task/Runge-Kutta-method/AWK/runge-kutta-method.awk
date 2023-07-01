# syntax: GAWK -f RUNGE-KUTTA_METHOD.AWK
# converted from BBC BASIC
BEGIN {
    print(" t    y         error")
    y = 1
    for (i=0; i<=100; i++) {
      t = i / 10
      if (t == int(t)) {
        actual = ((t^2+4)^2) / 16
        printf("%2d %12.7f %g\n",t,y,actual-y)
      }
      k1 = t * sqrt(y)
      k2 = (t + 0.05) * sqrt(y + 0.05 * k1)
      k3 = (t + 0.05) * sqrt(y + 0.05 * k2)
      k4 = (t + 0.10) * sqrt(y + 0.10 * k3)
      y += 0.1 * (k1 + 2 * (k2 + k3) + k4) / 6
    }
    exit(0)
}
