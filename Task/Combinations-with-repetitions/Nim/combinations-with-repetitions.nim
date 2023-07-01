import sugar, sequtils

proc combsReps[T](lst: seq[T], k: int): seq[seq[T]] =
  if k == 0:
    @[newSeq[T]()]
  elif lst.len == 0:
    @[]
  else:
    lst.combsReps(k - 1).map((x: seq[T]) => lst[0] & x) &
      lst[1 .. ^1].combsReps(k)

echo(@["iced", "jam", "plain"].combsReps(2))
echo toSeq(1..10).combsReps(3).len
