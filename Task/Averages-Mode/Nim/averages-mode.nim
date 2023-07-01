import tables

proc modes[T](xs: openArray[T]): T =
  var count = initCountTable[T]()
  for x in xs:
    count.inc(x)
  largest(count).key

echo modes(@[1,3,6,6,6,6,7,7,12,12,17])
echo modes(@[1,1,2,4,4])
