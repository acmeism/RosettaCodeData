proc cocktailShakerSort[T](a: var openarray[T]) =

  var beginIdx = 0
  var endIdx = a.len - 2

  while beginIdx <= endIdx:
    var newBeginIdx = endIdx
    var newEndIdx = beginIdx
    for i in beginIdx..endIdx:
      if a[i] > a[i + 1]:
        swap a[i], a[i + 1]
        newEndIdx = i

    endIdx = newEndIdx - 1

    for i in countdown(endIdx, beginIdx):
      if a[i] > a[i + 1]:
        swap a[i], a[i + 1]
        newBeginIdx = i

    beginIdx = newBeginIdx + 1

var a = @[4, 65, 2, -31, 0, 99, 2, 83, 782]
cocktailShakerSort a
echo a
