from times import epochTime

type PrimeType = int
iterator primesTreeFolding(): PrimeType {.closure.} =
  # needs a Co Inductive Stream - CIS...
  type
    CIS[T] = ref object
      head: T
      tail: () -> CIS[T]

  proc merge(xs, ys: CIS[PrimeType]): CIS[PrimeType] =
    let x = xs.head; let y = ys.head
    if x < y:
      CIS[PrimeType](head: x, tail: () => merge(xs.tail(), ys))
    elif y < x:
      CIS[PrimeType](
        head: y,
        tail: () => merge(xs, ys.tail()))
    else:
      CIS[PrimeType](
        head: x,
        tail: () => merge(xs.tail(), ys.tail()))

  proc pmults(p: PrimeType): CIS[PrimeType] =
    let inc = p + p
    proc mlts(c: PrimeType): CIS[PrimeType] =
      CIS[PrimeType](head: c, tail: () => mlts(c + inc))
    mlts(p * p)

  proc allmults(ps: CIS[PrimeType]): CIS[CIS[PrimeType]] =
    CIS[CIS[PrimeType]](
      head: pmults(ps.head),
      tail: () => allmults(ps.tail()))

  proc pairs(css: CIS[CIS[PrimeType]]): CIS[CIS[PrimeType]] =
    let cs0 = css.head; let rest0 = css.tail()
    CIS[CIS[PrimeType]](
      head: merge(cs0, rest0.head),
      tail: () => pairs(rest0.tail()))

  proc cmpsts(css: CIS[CIS[PrimeType]]): CIS[PrimeType] =
    let cs0 = css.head
    CIS[PrimeType](
      head: cs0.head,
      tail: () => merge(cs0.tail(), css.tail().pairs.cmpsts))

  proc minusAt(n: PrimeType, cs: CIS[PrimeType]): CIS[PrimeType] =
    var nn = n; var ncs = cs
    while nn >= ncs.head: nn += 2; ncs = ncs.tail()
    CIS[PrimeType](head: nn, tail: () => minusAt(nn + 2, ncs))

  proc oddprms(): CIS[PrimeType] =
    CIS[PrimeType](
      head: 3.PrimeType,
      tail: () => minusAt(5.PrimeType, oddprms().allmults.cmpsts))

  var prms =
    CIS[PrimeType](head: 2.PrimeType, tail: () => oddprms())
  while true: yield prms.head; prms = prms.tail()

stdout.write "The first 25 primes are:  "
var counter = 0
for p in primesTreeFolding():
  if counter >= 25: break
  stdout.write(p, " "); counter += 1
echo ""
start = epochTime()
counter = 0
for p in primesTreeFolding():
  if p > range: break else: counter += 1
elapsed = epochTime() - start
echo "There are ", counter, " primes up to 1000000."
echo "This test took ", elapsed, " seconds."
