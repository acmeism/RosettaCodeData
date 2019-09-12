import tables

type PrimeType = int
proc primesHashTable(): iterator(): PrimeType {.closure.} =
  iterator output(): PrimeType {.closure.} =
    # some initial values to avoid race and reduce initializations...
    yield 2.PrimeType; yield 3.PrimeType; yield 5.PrimeType; yield 7.PrimeType
    var h = initTable[PrimeType,PrimeType]()
    var n = 9.PrimeType
    let bps = primesHashTable()
    var bp = bps() # advance past 2
    bp = bps(); var q = bp * bp # to initialize with 3
    while true:
      if n >= q:
        let inc = bp + bp
        h.add(n + inc, inc)
        bp = bps(); q = bp * bp
      elif h.hasKey(n):
        var inc: PrimeType
        discard h.take(n, inc)
        var nxt = n + inc
        while h.hasKey(nxt): nxt += inc # ensure no duplicates
        h.add(nxt, inc)
      else: yield n
      n += 2.PrimeType
  output

stdout.write "The first 25 primes are:  "
var counter = 0
var iter = primesHashTable()
for p in iter():
  if counter >= 25: break else: stdout.write(p, " "); counter += 1
echo ""
let start = epochTime()
counter = 0
iter = primesHashTable()
for p in iter():
  if p > 1000000: break else: counter += 1
let elapsed = epochTime() - start
echo "The number of primes up to a million is:  ", counter
stdout.write("This test took ", elapsed, " seconds.\n")
