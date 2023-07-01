template times(x, y: untyped): untyped =
  for i in 1..x:
    y

10.times: # or times 10:  or times(10):
  echo "hi"
  echo "bye"
