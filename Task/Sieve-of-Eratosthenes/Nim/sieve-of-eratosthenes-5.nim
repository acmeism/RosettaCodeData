# a Page Segmented Odd-Only Bit-Packed Sieve of Eratosthenes...

from times import epochTime # for testing
from bitops import popCount

type Prime = uint64

let LIMIT = 1_000_000_000.Prime
let CPUL1CACHE = 16384 # in bytes

const FRSTSVPRM = 3.Prime

type
  BasePrime = uint32
  BasePrimeArray = seq[BasePrime]
  SieveBuffer = seq[byte] # byte size gives the most potential efficiency...

# define a general purpose lazy list to use as secondary base prime arrays feed
# NOT thread safe; needs a Mutex gate to make it so, but not threaded (yet)...
type
  BasePrimeArrayLazyList = ref object
    head: BasePrimeArray
    tailf: proc (): BasePrimeArrayLazyList {.closure.}
    tail: BasePrimeArrayLazyList
template makeBasePrimeArrayLazyList(hd: BasePrimeArray;
                      body: untyped): untyped = # factory constructor
  let thnk = proc (): BasePrimeArrayLazyList {.closure.} = body
  BasePrimeArrayLazyList(head: hd, tailf: thnk)
proc rest(lzylst: sink BasePrimeArrayLazyList): BasePrimeArrayLazyList {.inline.} =
  if lzylst.tailf != nil: lzylst.tail = lzylst.tailf(); lzylst.tailf = nil
  return lzylst.tail
iterator items(lzylst: BasePrimeArrayLazyList): BasePrime {.inline.} =
  var ll = lzylst
  while ll != nil:
    for bp in ll.head: yield bp
    ll = ll.rest

# count the number of zero bits (primes) in a SieveBuffer,
# uses native popCount for extreme speed;
# counts up to the bit index of the last bit to be counted...
proc countSieveBuffer(lsti: int; cmpsts: SieveBuffer): int =
  let lstw = (lsti shr 3) and -8; let lstm = lsti and 63 # last word and bit index!
  result = (lstw shl 3) + 64 # preset for all ones!
  let cmpstsa = cast[int](cmpsts[0].unsafeAddr)
  let cmpstslsta = cmpstsa + lstw
  for csa in countup(cmpstsa, cmpstslsta - 1, 8):
    result -= cast[ptr uint64](csa)[].popCount # subtract number of found ones!
  let msk = (0'u64 - 2'u64) shl lstm # mask for the unused bits in last word!
  result -= (cast[ptr uint64](cmpstslsta)[] or msk).popCount

# a fast fill SieveBuffer routine using pointers...
proc fillSieveBuffer(sb: var SieveBuffer) = zeroMem(sb[0].unsafeAddr, sb.len)

const BITMASK = [1'u8, 2, 4, 8, 16, 32, 64, 128] # faster than shifting!

# do sieving work, based on low starting value for the given buffer and
# the given lazy list of base prime arrays...
proc cullSieveBuffer(lwi: int; bpas: BasePrimeArrayLazyList;
                               sb: var SieveBuffer) =
  let len = sb.len; let szbits = len shl 3; let nxti = lwi + szbits
  for bp in bpas:
    let bpwi = ((bp.Prime - FRSTSVPRM) shr 1).int
    var s = (bpwi shl 1) * (bpwi + FRSTSVPRM.int) + FRSTSVPRM.int
    if s >= nxti: break
    if s >= lwi: s -= lwi
    else:
      let r = (lwi - s) mod bp.int
      s = (if r == 0: 0 else: bp.int - r)
    let clmt = szbits - (bp.int shl 3)
#    if len == CPUL1CACHE: continue
    if s < clmt:
      let slmt = s + (bp.int shl 3)
      while s < slmt:
        let msk = BITMASK[s and 7]
        for c in countup(s shr 3, len - 1, bp.int):
          sb[c] = sb[c] or msk
        s += bp.int
      continue
    while s < szbits:
      let w = s shr 3; sb[w] = sb[w] or BITMASK[s and 7]; s += bp.int # (1'u8 shl (s and 7))

proc makeBasePrimeArrays(): BasePrimeArrayLazyList # forward reference!

# an iterator over successive sieved buffer composite arrays,
# returning whatever type the cnvrtr produces from
# the low index and the culled SieveBuffer...
proc makePrimePages[T](
    strtwi, sz: int; cnvrtrf: proc (li: int; sb: var SieveBuffer): T {.closure.}
      ): (iterator(): T {.closure.}) =
  var lwi = strtwi; let bpas = makeBasePrimeArrays(); var cmpsts = newSeq[byte](sz)
  return iterator(): T {.closure.} =
    while true:
      fillSieveBuffer(cmpsts); cullSieveBuffer(lwi, bpas, cmpsts)
      yield cnvrtrf(lwi, cmpsts); lwi += cmpsts.len shl 3

# starts the secondary base primes feed with minimum size in bits set to 4K...
# thus, for the first buffer primes up to 8293,
# the seeded primes easily cover it as 97 squared is 9409.
proc makeBasePrimeArrays(): BasePrimeArrayLazyList =
  # converts an entire sieved array of bytes into an array of base primes,
  # to be used as a source of base primes as part of the Lazy List...
  proc sb2bpa(li: int; sb: var SieveBuffer): BasePrimeArray =
    let szbits = sb.len shl 3; let len = countSieveBuffer(szbits - 1, sb)
    result = newSeq[BasePrime](len); var j = 0
    for i in 0 ..< szbits:
      if (sb[i shr 3] and BITMASK[i and 7]) == 0'u8:
        result[j] = FRSTSVPRM.BasePrime + ((li + i) shl 1).BasePrime; j.inc
  proc nxtbparr(
      pgen: iterator (): BasePrimeArray {.closure.}): BasePrimeArrayLazyList =
    return makeBasePrimeArrayLazyList(pgen()): nxtbparr(pgen)
  # pre-seeding first array breaks recursive race,
  # dummy primes of all odd numbers starting at FRSTSVPRM (unculled)...
  var cmpsts = newSeq[byte](512)
  let dummybparr = sb2bpa(0, cmpsts)
  let fakebps = makeBasePrimeArrayLazyList(dummybparr): nil # used just once here!
  cullSieveBuffer(0, fakebps, cmpsts)
  return makeBasePrimeArrayLazyList(sb2bpa(0, cmpsts)):
    nxtbparr(makePrimePages(4096, 512, sb2bpa)) # lazy recursive call breaks race!

# iterator over primes from above page iterator;
# takes at least as long to enumerate the primes as sieve them...
iterator primesPaged(): Prime {.inline.} =
  yield 2
  proc mkprmarr(li: int; sb: var SieveBuffer): seq[Prime] =
    let szbits = sb.len shl 3; let low = FRSTSVPRM + (li + li).Prime; var j = 0
    let len = countSieveBuffer(szbits - 1, sb); result = newSeq[Prime](len)
    for i in 0 ..< szbits:
      if (sb[i shr 3] and BITMASK[i and 7]) == 0'u8:
        result[j] = low + (i + i).Prime; j.inc
  let gen = makePrimePages(0, CPUL1CACHE, mkprmarr)
  for prmpg in gen():
    for prm in prmpg: yield prm

proc countPrimesTo(range: Prime): int64 =
  if range < FRSTSVPRM: return (if range < 2: 0 else: 1)
  result = 1; let rngi = ((range - FRSTSVPRM) shr 1).int
  proc cntr(li: int; sb: var SieveBuffer): (int, int) {.closure.} =
    let szbits = sb.len shl 3; let nxti = li + szbits; result = (0, nxti)
    if nxti <= rngi: result[0] += countSieveBuffer(szbits - 1, sb)
    else: result[0] += countSieveBuffer(rngi - li, sb)
  let gen = makePrimePages(0, CPUL1CACHE, cntr)
  for count, nxti in gen():
    result += count; if nxti > rngi: break

# showing results...
echo "Page Segmented Bit-Packed Odds-Only Sieve of Eratosthenes"
echo "Needs at least ", CPUL1CACHE, " bytes of CPU L1 cache memory.\n"

stdout.write "First 25 primes:  "
var counter0 = 0
for p in primesPaged():
  if counter0 >= 25: break
  stdout.write(p, " "); counter0.inc
echo ""

stdout.write "The number of primes up to a million is:  "
var counter1 = 0
for p in primesPaged():
  if p > 1_000_000.Prime: break else: counter1.inc
stdout.write counter1, " - these both found by (slower) enumeration.\n"

let start = epochTime()
#[ # slow way to count primes takes as long to enumerate as sieve!
var counter = 0
for p in primesPaged():
  if p > LIMIT: break else: counter.inc
# ]#
let counter = countPrimesTo LIMIT # the fast way using native popCount!
let elpsd = epochTime() - start

echo "Found ", counter, " primes up to ", LIMIT, " in ", elpsd, " seconds."
