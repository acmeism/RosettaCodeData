import algorithm

func jortSort[T](a: openArray[T]): bool =
  a == a.sorted()

proc test[T](a: openArray[T]) =
  echo a, " is ", if a.jortSort(): "" else: "not ", "sorted"

test([1, 2, 3])
test([2, 3, 1])
echo ""
test(['a', 'b', 'c'])
test(['c', 'a', 'b'])
