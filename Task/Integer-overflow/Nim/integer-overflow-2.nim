{.push overflowChecks: off.}
try:
  var x: int32 = -2147483647
  x = -(x - 1)
  echo x   # -2147483648 — Wrong result as 2147483648 doesn't fit in an int32.
except OverflowDefect:
  echo "Overflow detected"      # Not executed.
{.pop.}
