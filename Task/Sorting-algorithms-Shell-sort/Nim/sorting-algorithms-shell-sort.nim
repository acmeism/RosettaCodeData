proc shellSort[T](a: var openarray[T]) =
  var h = a.len
  while h > 0:
    h = h div 2
    for i in h .. < a.len:
      let k = a[i]
      var j = i
      while j >= h and k < a[j-h]:
        a[j] = a[j-h]
        j -= h
      a[j] = k

var a = @[4, 65, 2, -31, 0, 99, 2, 83, 782]
shellSort a
echo a
