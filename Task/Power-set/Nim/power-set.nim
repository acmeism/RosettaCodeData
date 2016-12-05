import sets, hashes

proc hash(x): THash =
  var h = 0
  for i in x: h = h !& hash(i)
  result = !$h

proc powerset[T](inset: HashSet[T]): auto =
  result = toSet([initSet[T]()])

  for i in inset:
    var tmp = result
    for j in result:
      var k = j
      k.incl(i)
      tmp.incl(k)
    result = tmp

echo powerset(toSet([1,2,3,4]))
