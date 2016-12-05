template times(x: expr, y: stmt): stmt =
  for i in 1..x:
    y

10.times: # or times 10:
  echo "hi"
  echo "bye"
