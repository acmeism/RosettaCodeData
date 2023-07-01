try:
  var x: int32 = -2147483647
  x = -(x - 1)  # Raise overflow.
  echo x
except OverflowDefect:
  echo "Overflow detected"
