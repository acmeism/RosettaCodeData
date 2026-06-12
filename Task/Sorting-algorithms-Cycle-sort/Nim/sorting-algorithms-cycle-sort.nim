proc cycleSort[T](a: var openArray[T]): int =
  var position, writes: int = 0
  var item: T
  for cycleStart in a.low..a.high - 1:
    item = a[cycleStart]
    position = cycleStart
    for i in cycleStart + 1..a.high:
      if a[i] < item:
        inc position
    if position == cycleStart:
      continue
    while item == a[position]:
      inc position
    swap a[position], item
    inc writes
    while position != cycleStart:
      position = cycleStart
      for i in cycleStart + 1..a.high:
        if a[i] < item:
          inc position
      while item == a[position]:
        inc position
      swap a[position], item
      inc writes
  result = writes

var array1 = @[1, 9, 3, 5, 8, 4, 7, 0, 6, 2]
var array2 = @[0'f64, 1, 2, 2, 2, 2, 1, 9, 3.5, 5, 8, 4, 7, 0, 6]
var array3 = @["Greygill Hole", "Ogof Draenen", "Ogof Ffynnon Ddu", "Malham Tarn Pot"]
var array4 = @[-3.14 ,3, 1, 4, 1, 5, 9, 2, 6, 5, 3, 5, 8, 9, 7, 9, 3, 2, 3, 8, 4, 6, 2, 6, 4, 3, 3, 8, 3, 2, 7, 9, 5, 0, 2, 8, 8, 4]
var array5 = @["George Washington: Virginia", "John Adams: Massachusetts", "Thomas Jefferson: Virginia", "James Madison: Virginia", "James Monroe: Virginia"]
var writes = 0

echo "Original: ", $array1
writes = array1.cycleSort()
echo "Sorted:   ", $array1
echo "Total number of writes: ", writes, "\n"

echo "Original: ", $array2
writes = array2.cycleSort()
echo "Sorted:   ", $array2
echo "Total number of writes: ", writes, "\n"

echo "Original: ", $array3
writes = array3.cycleSort()
echo "Sorted:   ", $array3
echo "Total number of writes: ", writes, "\n"

echo "Original: ", $array4
writes = array4.cycleSort()
echo "Sorted:   ", $array4
echo "Total number of writes: ", writes, "\n"

echo "Original: ", $array5
writes = array5.cycleSort()
echo "Sorted:   ", $array5
echo "Total number of writes: ", writes
