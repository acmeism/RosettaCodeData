proc transpose[T](s: seq[seq[T]]): seq[seq[T]] =
  result = newSeq[seq[T]](s[0].len)
  for i in 0 .. s[0].high:
    result[i] = newSeq[T](s.len)
    for j in 0 .. s.high:
      result[i][j] = s[j][i]

let a = @[@[ 0, 1, 2, 3,  4],
          @[ 5, 6, 7, 8,  9],
          @[ 1, 0, 0, 0, 42]]
echo transpose(a)
