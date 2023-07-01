import bigints, times

iterator func_hamming() : BigInt =
  type Thunk[T] = proc(): T {.closure.}
  type Lazy[T] = ref object of RootObj # tuple[val: T, thnk: Thunk[T]]
    val: T
    thnk: Thunk[T]
  proc force[T](me: var Lazy[T]): T = # not thread-safe; needs lock on thunk
    if me.thnk != nil: me.val = me.thnk(); me.thnk = nil
    me.val
  type LazyList[T] = ref object of RootObj # tuple[hd: T, tl: Lazy[LazyList[T]]]
    hd: T
    tl: Lazy[LazyList[T]]
  type Mytype = LazyList[BigInt]
  proc merge(x, y: Mytype): Mytype =
    let xh = x.hd; let yh = y.hd
    if xh < yh:
      let mthnk = proc(): Mytype = merge x.tl.force, y
      let mlzy = Lazy[Mytype](thnk: mthnk)
      Mytype(hd: xh, tl: mlzy)
    else:
      let mthnk = proc(): Mytype = merge x, y.tl.force
      let mlzy = Lazy[Mytype](thnk: mthnk)
      Mytype(hd: yh, tl: mlzy)
  proc smult(m: int32, s: Mytype): Mytype =
    proc smults(ss: Mytype): Mytype =
      let mthnk = proc(): Mytype = ss.tl.force.smults
      let mlzy = Lazy[Mytype](thnk: mthnk)
      Mytype(hd: ss.hd * m, tl: mlzy)
    s.smults
  proc u(s: Mytype, n: int32): Mytype =
    var r: Mytype
    let mthnk = proc(): Mytype = r
    let mlzy = Lazy[Mytype](thnk: mthnk)
    let frst = Mytype(hd: initBigInt 1, tl: mlzy)
    if s == nil: r = smult(n, frst) else: r = merge(s, smult(n, frst))
    r
  var hmg: Mytype = nil
  for p in [5i32, 3i32, 2i32]: hmg = u(hmg, p)
  yield initBigInt 1
  while true: # loop almost forever
    yield initBigInt hmg.hd
    hmg = hmg.tl.force

var cnt = 1
for h in func_hamming():
  if cnt > 20: break
  write stdout, h, " "; cnt += 1
echo ""
cnt = 1
for h in func_hamming():
  if cnt < 1691: cnt += 1; continue
  else: echo h; break

let strt = epochTime()
var rslt: BigInt
cnt = 1
for h in func_hamming():
  if cnt < 1000000: cnt += 1; continue
  else: rslt = h; break
let stop = epochTime()

echo rslt
echo "This last took ", (stop - strt)*1000, " milliseconds."
