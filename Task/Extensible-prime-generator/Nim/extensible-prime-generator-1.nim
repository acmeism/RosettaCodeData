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
        h[n + inc] = inc
        bp = bps(); q = bp * bp
      elif h.hasKey(n):
        var inc: PrimeType
        discard h.take(n, inc)
        var nxt = n + inc
        while h.hasKey(nxt): nxt += inc # ensure no duplicates
        h[nxt] = inc
      else: yield n
      n += 2.PrimeType
  output

var num = 0
stdout.write "The first 20 primes are:  "
var iter = primesHashTable()
for p in iter():
  if num >= 20: break else: stdout.write(p, " "); num += 1
echo ""
stdout.write "The primes between 100 and 150 are:  "
iter = primesHashTable()
for p in iter():
  if p >= 150: break
  if p >= 100: stdout.write(p, " ")
echo ""
num = 0
iter = primesHashTable()
for p in iter():
  if p > 8000: break
  if p >= 7700: num += 1
echo "The number of primes between 7700 and 8000 is:  ", num
num = 1
iter = primesHashTable()
for p in iter():
  if num >= 10000:
    echo "The 10,000th prime is:  ", p
    break
  num += 1
var sum = 0
iter = primesHashTable()
for p in iter():
  if p >= 2_000_000:
    echo "The sum of the primes to two million is:  ", sum
    break
  sum += p
