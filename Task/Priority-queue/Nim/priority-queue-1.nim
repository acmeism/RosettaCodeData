type
  PriElem[T] = tuple
    data: T
    pri: int

  PriQueue[T] = object
    buf: seq[PriElem[T]]
    count: int

# first element not used to simplify indices
proc initPriQueue[T](initialSize = 4): PriQueue[T] =
  result.buf.newSeq(initialSize)
  result.buf.setLen(1)
  result.count = 0

proc add[T](q: var PriQueue[T], data: T, pri: int) =
  var n = q.buf.len
  var m = n div 2
  q.buf.setLen(n + 1)

  # append at end, then up heap
  while m > 0 and pri < q.buf[m].pri:
    q.buf[n] = q.buf[m]
    n = m
    m = m div 2

  q.buf[n] = (data, pri)
  q.count = q.buf.len - 1

proc pop[T](q: var PriQueue[T]): PriElem[T] =
  assert q.buf.len > 1
  result = q.buf[1]

  var qn = q.buf.len - 1
  var n = 1
  var m = 2
  while m < qn:
    if m + 1 < qn and q.buf[m].pri > q.buf[m+1].pri:
      inc m

    if q.buf[qn].pri <= q.buf[m].pri:
      break

    q.buf[n] = q.buf[m]
    n = m
    m = m * 2

  q.buf[n] = q.buf[qn]
  q.buf.setLen(q.buf.len - 1)
  q.count = q.buf.len - 1

var p = initPriQueue[string]()
p.add("Clear drains", 3)
p.add("Feed cat", 4)
p.add("Make tea", 5)
p.add("Solve RC tasks", 1)
p.add("Tax return", 2)

while p.count > 0:
  echo p.pop()
