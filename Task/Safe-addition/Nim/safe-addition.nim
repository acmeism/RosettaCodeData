import posix, strutils

proc `++`(a, b: float): tuple[lower, upper: float] =
  let
    a {.volatile.} = a
    b {.volatile.} = b
    orig = fegetround()
  discard fesetround FE_DOWNWARD
  result.lower = a + b
  discard fesetround FE_UPWARD
  result.upper = a + b
  discard fesetround orig

proc ff(a: float): string = a.formatFloat(ffDefault, 17)

for x, y in [(1.0, 2.0), (0.1, 0.2), (1e100, 1e-100), (1e308, 1e308)].items:
  let (d,u) = x ++ y
  echo x.ff, " + ", y.ff, " ="
  echo "    [", d.ff, ", ", u.ff, "]"
  echo "    size ", (u - d).ff, "\n"
