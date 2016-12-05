proc newSeqWith[T](len: int, init: T): seq[T] =
  result = newSeq[T] len
  for i in 0 .. <len:
    result[i] = init

var xs = newSeqWith(n, foo())
