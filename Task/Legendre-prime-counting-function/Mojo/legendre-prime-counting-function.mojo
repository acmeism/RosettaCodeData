from time import (now)

alias cLIMIT: UInt64 = 100_000_000_000

@always_inline
fn mkMasks() -> DTypePointer[DType.uint8]:
  let rslt = DTypePointer[DType.uint8].alloc(8)
  for i in range(8): rslt.offset(i).store(1 << i)
  return rslt

let masksp = mkMasks()

fn intsqrt(n: UInt64) -> UInt64:
  if n < 4:
    if n < 1: return 0 else: return 1
  var x: UInt64 = n; var qn: UInt64 = 0; var r: UInt64 = 0
  while qn < 64 and (1 << qn) <= n:
    qn += 2
  var q: UInt64 = 1 << qn
  while q > 1:
    if qn >= 64:
      q = 1 << (qn - 2); qn = 0
    else:
      q >>= 2
    let t: UInt64 =  r + q
    r >>= 1
    if x >= t:
      x -= t; r += q
  return r

fn countPrimes(n: UInt64) -> Int64:
  if n < 3:
    if n < 2: return 0
    else: return 1
  let rtlmt: Int = intsqrt(n).to_int() # precision limits range to maybe 1e16!
  let mxndx = (rtlmt - 1) >> 1
  @always_inline
  fn half(n: Int64) -> Int64    : return ((n - 1) // 2)
  @always_inline
  fn divide(nm: UInt64, d: UInt64) -> Int64: return ((nm * 1.0) / (d * 1.0)).to_int()
  let smalls = # current accumulated counts of odd primes 1 to sqrt range
    DTypePointer[DType.uint32].alloc(mxndx + 1)
  # initialized for no sieving whatsoever other than odds-only - partial sieved by 2:
  #   0 odd primes to 1; 1 odd prime to 3, etc....
  for i in range(mxndx + 1): smalls.offset(i).store(i)
  let roughs = # current odd k-rough numbers up to sqrt of range; k = 2
    DTypePointer[DType.uint32].alloc(mxndx + 1)
  # initialized to all odd positive numbers 1, 3, 5, ... sqrt range...
  for i in range(mxndx + 1): roughs.offset(i).store(i + i + 1)
  # array of current phi counts for above roughs...
  # these are not strictly `phi`'s since they also include the
  # count of base primes in order to match the above `smalls` definition!
  let larges = # starts as size of counts just as `roughs` so they align!
    DTypePointer[DType.uint64].alloc(mxndx + 1)
  # initialized for current roughs after accounting for even prime of two...
  for i in range(mxndx + 1): larges.offset(i).store((n // (i + i + 1) - 1) // 2)
  # cmpsts is a bit-packed boolean array representing
  # odd composite numbers from 1 up to rtlmt used for sieving...
  # initialized as "zeros" meaning all odd positives are potentially prime
  # note that this array starts at (and keeps) 1 to match the algorithm even
  # though 1 is not a prime, as 1 is important in computation of phi...
  let cmpsts = DTypePointer[DType.uint8].alloc((mxndx + 8) // 8)
  memset_zero(cmpsts, (mxndx + 8) // 8)

  # number of found base primes and current highest used rough index...
  var npc: Int = 0; var mxri: Int = mxndx
  for i in range(1, mxndx + 1): # start at index for 3; i will never reach mxndx...
    let sqri = (i + i) * (i + 1) # computation of square index!
    if sqri > mxndx: break # stop partial sieving due to square index limit!
    if (cmpsts.offset(i >> 3).load() & masksp.offset(i & 7).load()) != 0: continue # if not prime
    # culling the base prime from cmpsts means it will never be found again
    let cp = cmpsts.offset(i >> 3)
    cp.store(cp.load() | masksp.offset(i & 7).load()) # cull base prime
    let bp = i + i + 1 # base prime from index!
    for c in range(sqri, mxndx + 1, bp): # SoE culling of all bp multiples...
      let cp = cmpsts.offset(c >> 3); cp.store(cp.load() | masksp.offset(c & 7).load())
    # partial sieving to current base prime is now completed!

    var ri: Int = 0 # to keep track of current used roughs index!
    for k in range(mxri + 1): # processing over current roughs size...
      # q is not necessarily a prime but may be a
      # product of primes not yet culled by partial sieving;
      # this is what saves operations compared to recursive Legendre:
      let q: UInt64 = roughs.offset(k).load().to_int(); let qi = q >> 1 # index of always odd q!
      # skip over values of `q` already culled in the last partial sieve:
      if (cmpsts.offset(qi >> 3).load() & masksp.offset(qi & 7).load()) != 0: continue
      # since `q` cannot be equal to bp due to cull of bp and above skip;
      let d: UInt64 = bp * q # `d` is odd product of some combination of odd primes!
      # the following computation is essential to the algorithm's speed:
      # see above description in the text for how this works:
      larges.offset(ri).store(larges.offset(k).load() -
                   (larges.offset(smalls.offset(d >> 1).load().to_int() - npc).load() if d <= rtlmt
                    else smalls.offset(half(divide(n, d))).load().to_int()) + npc)
      # eliminate rough values that have been culled in partial sieve:
      # note that `larges` and `roughs` indices relate to each other!
      roughs.offset(ri).store(q.to_int()); ri += 1 # update rough value; advance rough index

    var m = mxndx # adjust `smalls` counts for the newly culled odds...
    # this is faster than recounting over the `cmpsts` array for each loop...
    for k in range(((rtlmt // bp) - 1) | 1, bp - 1, -2): # k always odd!
      # `c` is correction from current count to desired count...
      # `e` is end limit index no correction is necessary for current cull...
      let c = smalls.offset(k >> 1).load() - npc; let e = (k * bp) >> 1
      while m >= e:
        let cp = smalls.offset(m)
        cp.store(cp.load() - c); m -= 1 # correct over range down to `e`
    mxri = ri - 1; npc += 1 # set next loop max roughs index; count base prime
  # now `smalls` is a LUT of odd prime accumulated counts for all odd primes;
  # `roughs` is exactly the "k-roughs" up to the sqrt of range with `k` the
  #    index of the next prime above the quad root of the range;
  # `larges` is the partial prime counts for each of the `roughs` values...
  # note that `larges` values include the count of the odd base primes!!!
  # `cmpsts` are never used again!

  # the following does the top most "phi tree" calculation:
  var result: Int64 = larges.load().to_int() # the answer to here is all valid `phis`
  for i in range(1, mxri + 1): result -= larges.offset(i).load().to_int() # combined here by subtraction
  # compensate for the included odd base prime counts over subracted above:
  result += ((mxri + 1 + 2 * (npc - 1)) * mxri // 2)

  # This loop adds the counts due to the products of the `roughs` primes,
  # of which we only use two different ones at a time, as all the
  # combinations with lower primes than the cube root of the range have
  # already been computed and included with the previous major loop...
  # see text description above for how this works...
  for j in range(1, mxri + 1):  # for all `roughs` (now prime) not including one:
    let p: UInt64 = roughs.offset(j).load().to_int()
    let m: UInt64 = (n // p) # `m` is the `p` quotient
    # so that the end limit `e` can be calculated based on `n`/(`p`^2)
    let e: Int = smalls.offset(half((m // p).to_int())).load().to_int() - npc
    # following break test equivalent to non-memoization/non-splitting optmization:
    if e <= j: break # stop at about `p` of cube root of range!
    for k in range(j + 1, e + 1): # for all `roughs` greater than `p` to end limit:
      result += smalls.offset(half(divide(m, roughs.offset(k).load().to_int()))).load().to_int()
    # compensate for all the extra base prime counts just added!
    result -= ((e - j) * (npc + j - 1))

  result += 1 # include the count for the only even prime of two
  smalls.free(); roughs.free(); larges.free(); cmpsts.free()

  return result

fn main():
  var pow: Int = 1
  for i in range(10):
    print('10^', i, '=', countPrimes(pow))
    pow *= 10
  let start = now()
  let answr = countPrimes(cLIMIT)
  let elpsd = (now() - start) / 1000000
  print("Found", answr, "primes up to", cLIMIT, "in", elpsd, "milliseconds.")
