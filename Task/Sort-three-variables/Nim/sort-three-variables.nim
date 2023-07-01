proc sortThree[T](a, b, c: var T) =
  # Bubble sort, why not?
  while not (a <= b and b <= c):
    if a > b: swap a, b
    if b > c: swap b, c

proc testWith[T](a, b, c: T) =
  var (x, y, z) = (a, b, c)
  echo "Before: ", x, ", ", y, ", ", z
  sortThree(x, y, z)
  echo "After: ", x, ", ", y, ", ", z

testWith(6, 4, 2)
testWith(0.9, -37.1, 4.0)
testWith("lions", "tigers", "bears")
