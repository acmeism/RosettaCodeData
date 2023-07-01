# compile with `--release --no-debug` for speed...

alias Prime = UInt64
alias PrimeNdx = Int64
alias PrimeArr = Array(Prime)
alias SieveBuffer = Pointer(UInt8)
alias BasePrime = UInt32
alias BasePrimeArr = Array(BasePrime)

CPUL1CACHE = 131072 # 16 Kilobytes in nimber of bits

BITMASK = Pointer(UInt8).malloc(8) { |i| 1_u8 << i }

# Count number of non-composite (zero) bits within index range...
# sieve buffer is always evenly divisible by 64-bit words...
private def count_page_to(ndx : Int32, sb : SieveBuffer)
  lstwrdndx = ndx >> 6; mask = (~1_u64) << (ndx & 63)
  cnt = lstwrdndx * 64 + 64; sbw = sb.as(Pointer(UInt64))
  lstwrdndx.times { |i| cnt -= sbw[i].popcount }
  cnt - (sbw[lstwrdndx] | mask).popcount
end

# Cull composite bits from sieve buffer using base prime arrays;
# starting at overall given prime index for given buffer bit size...
private def cull_page(pndx : PrimeNdx, bitsz : Int32,
              bps : Iterator(BasePrimeArr), sb : SieveBuffer)
  bps.each { |bpa|
    bpa.each { |bpu32|
      bp = bpu32.to_i64; bpndx = (bp - 3) >> 1
      swi = (bpndx + bpndx) * (bpndx + 3) + 3 # calculate start prime index
      return if swi >= pndx + bitsz.to_i64
      bpi = bp.to_i32 # calculate buffer start culling index...
      bi = (swi >= pndx) ? (swi - pndx).to_i32 : begin
        r = (pndx - swi) % bp; r == 0 ? 0 : bpi - r.to_i32
      end
      # when base prime is small enough, cull using strided loops to
      # simplify the inner loops at the cost of more loop overhead...
      # allmost all of the work is done by the following loop...
      if bpi < (bitsz >> 4)
        bilmt = bi + (bpi << 3); cplmt = sb + (bitsz >> 3)
        bilmt = CPUL1CACHE if bilmt > CPUL1CACHE
        while bi < bilmt
          cp = sb + (bi >> 3); msk = BITMASK[bi & 7]
          while cp < cplmt # use pointer to save loop overhead
            cp[0] |= msk; cp += bpi
          end
          bi += bpi
        end
      else
        while bi < bitsz # bitsz
          sb[bi >> 3] |= BITMASK[bi & 7]; bi += bpi
        end
      end } }
end

# Iterator over processed prime pages, polymorphic by the converter function...
private class PagedResults(T)
  @bpas : BasePrimeArrays
  @cmpsts : SieveBuffer

  def initialize(@prmndx : PrimeNdx,
                 @cmpstsbitsz : Int32,
                 @cnvrtrfnc : (Int64, Int32, SieveBuffer) -> T)
    @bpas = BasePrimeArrays.new
    @cmpsts = SieveBuffer.malloc(((@cmpstsbitsz + 63) >> 3) & (-8))
  end

  private def dopage
    (@prmndx..).step(@cmpstsbitsz.to_i64).map { |pn|
        @cmpsts.clear(@cmpstsbitsz >> 3)
        cull_page(pn, @cmpstsbitsz, @bpas.each, @cmpsts)
        @cnvrtrfnc.call(pn, @cmpstsbitsz, @cmpsts) }
  end

  def each
    dopage
  end

  def each(& : T -> _) : Nil
    itr = dopage
    while true
      value = itr.next
      break if value.is_a?(Iterator::Stop)
      yield value
    end
  end
end

# Secondary memoized chain of BasePrime arrays (by small page size),
# which is actually a iterable lazy list (memoized) of BasePrimeArr;
# Crystal has closures, so it is easy to implement a LazyList class
# which memoizes the results of the thunk so it is only executed once...
private class BasePrimeArrays
  @baseprmarr : BasePrimeArr # head of lezy list
  @tail : BasePrimeArrays? = nil # tail starts as non-existing

  def initialize # special case for first page of base primes
    # converter of sieve buffer to base primes array...
    sb2bparrprc = -> (pn : PrimeNdx, bl : Int32, sb : SieveBuffer) {
      cnt = count_page_to(bl - 1, sb)
      bparr = BasePrimeArr.new(cnt, 0); j = 0
      bsprm = (pn + pn + 3).to_u32
      bl.times.each { |i|
        next if (sb[i >> 3] & BITMASK[i & 7]) != 0
        bparr[j] = bsprm + (i + i).to_u32; j += 1 }
      bparr }

    cmpsts = SieveBuffer.malloc 128 # fake bparr for first iter...
    frstbparr = sb2bparrprc.call(0_i64, 1024, cmpsts)
    cull_page(0_i64, 1024, Iterator.of(frstbparr).each, cmpsts)
    @baseprmarr = sb2bparrprc.call(0_i64, 1024, cmpsts)

    # initialization of pages after the first is deferred to avoid data race...
    initbpas = -> { PagedResults.new(1024_i64, 1024, sb2bparrprc).each }
    # recursive LazyList generator function...
    nxtbpa = uninitialized Proc(Iterator(BasePrimeArr), BasePrimeArrays)
    nxtbpa = -> (bppgs : Iterator(BasePrimeArr)) {
      nbparr = bppgs.next
      abort "Unexpectedbase primes end!!!" if nbparr.is_a?(Iterator::Stop)
      BasePrimeArrays.new(nbparr, ->{ nxtbpa.call(bppgs) }) }
    @thunk = ->{ nxtbpa.call(initbpas.call) }
  end
  def initialize(@baseprmarr : BasePrimeArr, @thunk : Proc(BasePrimeArrays))
  end
  def initialize(@baseprmarr : BasePrimeArr, @thunk : Proc(Nil))
  end
  def initialize(@baseprmarr : BasePrimeArr, @thunk : Nil)
  end

  def tail # not thread safe without a lock/mutex...
    if thnk = @thunk
      @tail = thnk.call; @thunk = nil
    end
    @tail
  end

  private class BasePrimeArrIter # iterator over BasePrime arrays...
    include Iterator(BasePrimeArr)
    @dbparrs : Proc(BasePrimeArrays?)

    def initialize(fromll : BasePrimeArrays)
      @dbparrs = ->{ fromll.as(BasePrimeArrays?) }
    end

    def next
      if bpas = @dbparrs.call
        rslt = bpas.@baseprmarr; @dbparrs = -> { bpas.tail }; rslt
      else
        abort "Unexpected end of base primes array iteration!!!"
      end
    end
  end

  def each
    BasePrimeArrIter.new(self)
  end
end

# An "infinite" extensible iteration of primes,...
def primes
  sb2prms = ->(pn : PrimeNdx, bitsz : Int32, sb : SieveBuffer) {
    cnt = count_page_to(bitsz - 1, sb)
    prmarr = PrimeArr.new(cnt, 0); j = 0
    bsprm = (pn + pn + 3).to_u64
    bitsz.times.each { |i|
      next if (sb[i >> 3] & BITMASK[i & 7]) != 0
      prmarr[j] = bsprm + (i + i).to_u64; j += 1 }
    prmarr
  }
  (2_u64..2_u64).each
    .chain PagedResults.new(0, CPUL1CACHE, sb2prms).each.flat_map { |prmspg| prmspg.each }
end

# Counts number of primes to given limit...
def primes_count_to(lmt : Prime)
  if lmt < 3
    lmt < 2 ? return 0 : return 1
  end
  lmtndx = ((lmt - 3) >> 1).to_i64
  sb2cnt = ->(pn : PrimeNdx, bitsz : Int32, sb : SieveBuffer) {
    pglmt = pn + bitsz.to_i64 - 1
    if (pn + CPUL1CACHE.to_i64) > lmtndx
      Tuple.new(count_page_to((lmtndx - pn).to_i32, sb).to_i64, pglmt)
    else
      Tuple.new(count_page_to(bitsz - 1, sb).to_i64, pglmt)
    end
  }
  count = 1
  PagedResults.new(0, CPUL1CACHE, sb2cnt).each { |(cnt, lmt)|
    count += cnt; break if lmt >= lmtndx }
  count
end

print "The primes up to 100 are: "
primes.each.take_while { |p| p <= 100_u64 }.each { |p| print " ", p }
print ".\r\nThe Number of primes up to a million is "
print primes.each.take_while { |p| p <= 1_000_000_u64 }.size
print ".\r\nThe number of primes up to a billion is "
start_time = Time.monotonic
# answr = primes.each.take_while { |p| p <= 1_000_000_000_u64 }.size # slow way
answr = primes_count_to(1_000_000_000) # fast way
elpsd = (Time.monotonic - start_time).total_milliseconds
print "#{answr} in #{elpsd} milliseconds.\r\n"
