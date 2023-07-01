# syntax: GAWK -f ARCHIMEDEAN_SPIRAL.AWK
# converted from Applesoft BASIC
BEGIN {
    x_min = y_min = 9999
    x_max = y_max = 0
    h = 96
    w = h + h / 2
    a = 1
    b = 1
    m = 6 * 3.1415926
    step = .02
    for (t=step; t<=m; t+=step) { # build spiral
      r = a + b * t
      x = int(r * cos(t) + w)
      y = int(r * sin(t) + h)
      if (x <= 0 || y <= 0) { continue }
      if (x >= 280 ) { continue }
      if (y >= 192) { continue }
      arr[x,y] = "*"
      x_min = min(x_min,x)
      x_max = max(x_max,x)
      y_min = min(y_min,y)
      y_max = max(y_max,y)
    }
    for (i=x_min; i<=x_max; i++) { # print spiral
      rec = ""
      for (j=y_min; j<=y_max; j++) {
        rec = sprintf("%s%1s",rec,arr[i,j])
      }
      printf("%s\n",rec)
    }
    exit(0)
}
function max(x,y) { return((x > y) ? x : y) }
function min(x,y) { return((x < y) ? x : y) }
