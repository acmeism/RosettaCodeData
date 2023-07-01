import sets, hashes

proc hash(x: HashSet[int]): Hash =
  var h = 0
  for i in x: h = h !& hash(i)
  result = !$h

proc powerset[T](inset: HashSet[T]): HashSet[HashSet[T]] =
  result.incl(initHashSet[T]())  # Initialized with empty set.
  for val in inset:
    let previous = result
    for aSet in previous:
      var newSet = aSet
      newSet.incl(val)
      result.incl(newSet)

echo powerset([1,2,3,4].toHashSet())
