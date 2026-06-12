proc twoSum(src: openarray[int], target: int): array[2, int] =
  if src.len < 2:
    return

  for base in 0 .. (src.len - 2):
    for ext in (base + 1) ..< src.len:
      if src[base] + src[ext] == target:
        result[0] = base
        result[1] = ext


proc main =
  var data0 = [0, 2, 11, 19, 90]
  var res = twoSum(data0, 21)
  assert(res == [1, 3])

  var data1 = [0, 2, 11, 19, 90]
  res = twoSum(data1, 22)
  assert(res == [0, 0])

  var data2 = [1]
  res = twoSum(data2, 22)
  assert(res == [0, 0])

  var data3 = [1, 99]
  res = twoSum(data3, 100)
  assert(res == [0, 1])

  var data4 = [1, 99]
  res = twoSum(data4, 101)
  assert(res == [0, 0])


main()
