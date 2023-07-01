import algorithm, strutils

# Definition of a range of values of type T.
type Range[T] = array[2, T]

proc `<`(a, b: Range): bool {.inline.} =
  ## Check if range "a" is less than range "b". Needed for sorting.
  if a[0] == b[0]:
    a[1] < b[1]
  else:
    a[0] < b[0]


proc consolidate[T](rangeList: varargs[Range[T]]): seq[Range[T]] =
  ## Consolidate a list of ranges of type T.

  # Build a sorted list of normalized ranges.
  var list: seq[Range[T]]
  for item in rangeList:
    list.add if item[0] <= item[1]: item else: [item[1], item[0]]
  list.sort()

  # Build the consolidated list starting from "smallest" range.
  result.add list[0]
  for i in 1..list.high:
    let rangeMin = result[^1]
    let rangeMax = list[i]
    if rangeMax[0] <= rangeMin[1]:
      result[^1] = [rangeMin[0], max(rangeMin[1], rangeMax[1])]
    else:
      result.add rangeMax


proc `$`[T](r: Range[T]): string {.inline.} =
  # Return the string representation of a range.
  when T is SomeFloat:
    "[$1, $2]".format(r[0].formatFloat(ffDecimal, 1), r[1].formatFloat(ffDecimal, 1))
  else:
    "[$1, $2]".format(r[0], r[1])

proc `$`[T](s: seq[Range[T]]): string {.inline.} =
  ## Return the string representation of a sequence of ranges.
  s.join(", ")


when isMainModule:

  proc test[T](rangeList: varargs[Range[T]]) =
    echo ($(@rangeList)).alignLeft(52), "→   ", consolidate(rangeList)

  test([1.1, 2.2])
  test([6.1, 7.2], [7.2, 8.3])
  test([4, 3], [2, 1])
  test([4.0, 3.0], [2.0, 1.0], [-1.0, -2.0], [3.9, 10.0])
  test([1, 3], [-6, -1], [-4, -5], [8, 2], [-6, -6])
