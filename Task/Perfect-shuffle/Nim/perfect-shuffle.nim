import sequtils, strutils

proc newValList(size: Positive): seq[int] =
  if (size and 1) != 0:
    raise newException(ValueError, "size must be even.")
  result = toSeq(1..size)


func shuffled(list: seq[int]): seq[int] =
  result.setLen(list.len)
  let half = list.len div 2
  for i in 0..<half:
    result[2 * i] = list[i]
    result[2 * i + 1] = list[half + i]


for size in [8, 24, 52, 100, 1020, 1024, 10000]:
  let initList = newValList(size)
  var valList = initList
  var count = 0
  while true:
    inc count
    valList = shuffled(valList)
    if valList == initList:
      break
  echo ($size).align(5), ": ", ($count).align(4)
