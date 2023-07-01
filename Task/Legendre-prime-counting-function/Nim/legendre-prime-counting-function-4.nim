# compile with: nim c -d:danger -t:-march=native --gc:arc

from std/monotimes import getMonoTime, `-`
from std/times import inMilliseconds
from std/math import sqrt

let masks = [ 1'u8, 2, 4, 8, 16, 32, 64, 128 ] # faster than bit twiddling
let masksp = cast[ptr[UncheckedArray[byte]]](unsafeAddr(masks[0]))

# non-recursive Legendre prime counting function for a range `n`...
# this has O(n^(3/4)/((log n)^2)) time complexity; O(n^(1/2)) space complexity.
proc countPrimes(n: int64): int64 =
  if n < 3: # can't odd sieve for value less than 3!
    return if n < 2: 0 else: 1
  else:
    proc half(n: int): int {.inline.} = (n - 1) shr 1 # convenience conversion to index
    # dividing using float64 is faster than int64 for some CPU's...
    # precision limits range to maybe 1e16!
    proc divide(nm, d: int64): int {.inline.} = (nm.float64 / d.float64).int
    let rtlmt = n.float64.sqrt.int # precision limits range to maybe 1e16!
    let mxndx = (rtlmt - 1) div 2
    var smalls = # current accumulated counts of odd primes 1 to sqrt range
      cast[ptr[UncheckedArray[uint32]]](alloc(sizeof(uint32) * (mxndx + 1)))
    # initialized for no sieving whatsoever other than odds-only - partial sieved by 2:
    #   0 odd primes to 1; 1 odd prime to 3, etc....
    for i in 0 .. mxndx: smalls[i] = i.uint32
    var roughs = # current odd k-rough numbers up to sqrt of range; k = 2
      cast[ptr[UncheckedArray[uint32]]](alloc(sizeof(uint32) * (mxndx + 1)))
    # initialized to all odd positive numbers 1, 3, 5, ... sqrt range...
    for i in 0 .. mxndx: roughs[i] = (i + i + 1).uint32
    # array of current phi counts for above roughs...
    # these are not strictly `phi`'s since they also include the
    # count of base primes in order to match the above `smalls` definition!
    var larges = # starts as size of counts just as `roughs` so they align!
      cast[ptr[UncheckedArray[int64]]](alloc(sizeof(int64) * (mxndx + 1)))
    # initialized for current roughs after accounting for even prime of two...
    for i in 0 .. mxndx: larges[i] = ((n div (i + i + 1) - 1) div 2).int64
    # cmpsts is a bit-packed boolean array representing
    # odd composite numbers from 1 up to rtlmt used for sieving...
    # initialized as "zeros" meaning all odd positives are potentially prime
    # note that this array starts at (and keeps) 1 to match the algorithm even
    # though 1 is not a prime, as 1 is important in computation of phi...
    var cmpsts = cast[ptr[UncheckedArray[byte]]](alloc0((mxndx + 8) div 8))

    # number of found base primes and current highest used rough index...
    var npc = 0; var mxri = mxndx
    for i in 1 .. mxndx: # start at index for 3; i will never reach mxndx...
      let sqri = (i + i) * (i + 1) # computation of square index!
      if sqri > mxndx: break # stop partial sieving due to square index limit!
      if (cmpsts[i shr 3] and masksp[i and 7]) != 0'u8: continue # if not prime
      # culling the base prime from cmpsts means it will never be found again
      cmpsts[i shr 3] = cmpsts[i shr 3] or masksp[i and 7] # cull base prime
      let bp = i + i + 1 # base prime from index!
      for c in countup(sqri, mxndx, bp): # SoE culling of all bp multiples...
        let w = c shr 3; cmpsts[w] = cmpsts[w] or masksp[c and 7]
      # partial sieving to current base prime is now completed!

      var ri = 0 # to keep track of current used roughs index!
      for k in 0 .. mxri: # processing over current roughs size...
        # q is not necessarily a prime but may be a
        # product of primes not yet culled by partial sieving;
        # this is what saves operations compared to recursive Legendre:
        let q = roughs[k].int; let qi = q shr 1 # index of always odd q!
        # skip over values of `q` already culled in the last partial sieve:
        if (cmpsts[qi shr 3] and masksp[qi and 7]) != 0'u8: continue
        # since `q` cannot be equal to bp due to cull of bp and above skip;
        let d = bp * q # `d` is odd product of some combination of odd primes!
        # the following computation is essential to the algorithm's speed:
        # see above description in the text for how this works:
        larges[ri] = larges[k] -
                     (if d <= rtlmt: larges[smalls[d shr 1].int - npc]
                      else: smalls[half(divide(n, d.int64))].int64) + npc.int64
        # eliminate rough values that have been culled in partial sieve:
        # note that `larges` and `roughs` indices relate to each other!
        roughs[ri] = q.uint32; ri += 1 # update rough value; advance rough index

      var m = mxndx # adjust `smalls` counts for the newly culled odds...
      # this is faster than recounting over the `cmpsts` array for each loop...
      for k in countdown(((rtlmt div bp) - 1) or 1, bp, 2): # k always odd!
        # `c` is correction from current count to desired count...
        # `e` is end limit index no correction is necessary for current cull...
        let c = smalls[k shr 1] - npc.uint32; let e = (k * bp) shr 1
        while m >= e: smalls[m] -= c; m -= 1 # correct over range down to `e`
      mxri = ri - 1; npc += 1 # set next loop max roughs index; count base prime
    # now `smalls` is a LUT of odd prime accumulated counts for all odd primes;
    # `roughs` is exactly the "k-roughs" up to the sqrt of range with `k` the
    #    index of the next prime above the quad root of the range;
    # `larges` is the partial prime counts for each of the `roughs` values...
    # note that `larges` values include the count of the odd base primes!!!
    # `cmpsts` are never used again!

    # the following does the top most "phi tree" calculation:
    result = larges[0] # the answer to here is all valid `phis`
    for i in 1 .. mxri: result -= larges[i] # combined here by subtraction
    # compensate for the included odd base prime counts over subracted above:
    result += ((mxri + 1 + 2 * (npc - 1)) * mxri div 2).int64

    # This loop adds the counts due to the products of the `roughs` primes,
    # of which we only use two different ones at a time, as all the
    # combinations with lower primes than the cube root of the range have
    # already been computed and included with the previous major loop...
    # see text description above for how this works...
    for j in 1 .. mxri:  # for all `roughs` (now prime) not including one:
      let p = roughs[j].int64; let m = n div p # `m` is the `p` quotient
      # so that the end limit `e` can be calculated based on `n`/(`p`^2)
      let e = smalls[half((m div p).int)].int - npc
      # following break test equivalent to non-memoization/non-splitting optmization:
      if e <= j: break # stop at about `p` of cube root of range!
      for k in j + 1 .. e: # for all `roughs` greater than `p` to end limit:
         result += smalls[half(divide(m, roughs[k].int64))].int64
      # compensate for all the extra base prime counts just added!
      result -= ((e - j) * (npc + j - 1)).int64

    result += 1 # include the count for the only even prime of two
    smalls.dealloc; roughs.dealloc; larges.dealloc; cmpsts.dealloc

let strt = getMonoTime()
var pow = 1'i64
for i in 0 .. 9: echo "π(10^", i, ") = ", pow.countPrimes; pow *= 10
let elpsd = (getMonoTime() - strt).inMilliseconds
echo "This took ", elpsd, " milliseconds."
