from times import inMilliseconds
import std/monotimes, bigints
from math import log2

type TriVal = (uint32, uint32, uint32)
type LogRep = (float64, TriVal)
type LogRepf = proc(x: LogRep): LogRep
const one: LogRep = (0.0f64, (0'u32, 0'u32, 0'u32))
proc `<`(me: LogRep, othr: LogRep): bool = me[0] < othr[0]

proc convertTrival2BigInt(tv: TriVal): BigInt =
  proc xpnd(bs: uint, v: uint32): BigInt =
    result = initBigInt 1;
    var bsm = initBigInt bs;
    var vm = v.uint
    while vm > 0:
      if (vm and 1) != 0: result *= bsm
      bsm = bsm * bsm   # bsm *= bsm crashes.
      vm = vm shr 1
  result = (2.xpnd  tv[0]) * (3.xpnd tv[1]) * (5.xpnd tv[2])

const lb2 = 1.0'f64
const lb3 = 3.0'f64.log2
const lb5 = 5.0'f64.log2

proc mul2(me: LogRep): LogRep =
  let (lr, tpl) = me; let (x2, x3, x5) = tpl
  (lr + lb2, (x2 + 1, x3, x5))

proc mul3(me: LogRep): LogRep =
  let (lr, tpl) = me; let (x2, x3, x5) = tpl
  (lr + lb3, (x2, x3 + 1, x5))

proc mul5(me: LogRep): LogRep =
  let (lr, tpl) = me; let (x2, x3, x5) = tpl
  (lr + lb5, (x2, x3, x5 + 1))

type
  LazyList = ref object
    hd: LogRep
    tlf: proc(): LazyList {.closure.}
    tl: LazyList

proc rest(ll: LazyList): LazyList = # not thread-safe; needs lock on thunk
  if ll.tlf != nil: ll.tl = ll.tlf(); ll.tlf = nil
  ll.tl

iterator log_func_hammings(until: int): TriVal =
  proc merge(x, y: LazyList): LazyList =
    let xh = x.hd
    let yh = y.hd
    if xh < yh: LazyList(hd: xh, tlf: proc(): auto = merge x.rest, y)
    else: LazyList(hd: yh, tlf: proc(): auto = merge x, y.rest)
  proc smult(mltf: LogRepf; s: LazyList): LazyList =
    proc smults(ss: LazyList): LazyList =
      LazyList(hd: ss.hd.mltf, tlf: proc(): auto = ss.rest.smults)
    s.smults
  proc unnsm(s: LazyList, mltf: LogRepf): LazyList =
    var r: LazyList = nil
    let frst = LazyList(hd: one, tlf: proc(): LazyList = r)
    r = if s == nil: smult mltf, frst else: s.merge smult(mltf, frst)
    r
  yield one[1]
  var hmpll: LazyList = ((nil.unnsm mul5).unnsm mul3).unnsm mul2
  for _ in 2 .. until:
    yield hmpll.hd[1]; hmpll = hmpll.rest # almost forever

proc main =
  stdout.write "The first 20 hammings are:  "
  for h in log_func_hammings(20): stdout.write h.convertTrival2BigInt, " "

  var lsth: TriVal
  for h in log_func_hammings(1691): lsth = h
  echo "\r\nThe 1691st Hamming number is:  ", lsth.convertTriVal2BigInt

  let strt = getMonotime()
  for h in log_func_hammings(1000000): lsth = h
  let elpsd = (getMonotime() - strt).inMilliseconds
  echo "The millionth Hamming number is:  ", lsth.convertTriVal2BigInt
  echo "This last took ", elpsd, " milliseconds."

main()
