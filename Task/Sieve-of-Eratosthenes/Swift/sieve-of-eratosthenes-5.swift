import Foundation

typealias Prime = UInt64
typealias BasePrime = UInt32
typealias SieveBuffer = [UInt8]
typealias BasePrimeArray = [UInt32]

// the lazy list decribed problems don't affect its use here as
// it is only used here for its memoization properties and not consumed...
// In fact a consumed deferred list would be better off to use a CIS as above!

// a lazy list to memoize the progression of base prime arrays...
// there is some bug in Swift 4.2 that generating a LazyList<T> with a
// function and immediately using an extension method on it without
// first storing it to a variable results in mem seg fault for large
// ranges in the order of a million; in order to write a consuming
// function, one must write a function passing in a generator thunk, and
// immediately call a `makeIterator()` on it before storing, then doing a
// iteration on the iterator; doing a for on the immediately produced
// LazyList<T> (without storing it) also works, but this means we have to
// implement the "higher order functions" ourselves.
// this bug may have something to do with "move sematics".
class LazyList<T> : LazySequenceProtocol {
  internal typealias Thunk<T> = () -> T
  let head : T
  internal var _thnk: Thunk<LazyList<T>?>?
  lazy var tail: LazyList<T>? = {
    let tl = self._thnk?(); self._thnk = nil
    return tl
  }()
  init(_ hd: T, _ thnk: @escaping Thunk<LazyList<T>?>) {
    self.head = hd; self._thnk = thnk
  }
  struct LLSeqIter : IteratorProtocol, LazySequenceProtocol {
    @usableFromInline
    internal var _isfirst: Bool = true
    @usableFromInline
    internal var _current: LazyList<T>
    @inlinable // ensure that reference is not released by weak reference
    init(_ base: LazyList<T>) { self._current = base }
    @inlinable // can't be called by multiple threads on same LLSeqIter...
    mutating func next() -> T? {
      let curll = self._current
      if (self._isfirst) { self._isfirst = false; return curll.head }
      let ncur = curll.tail
      if (ncur == nil) { return nil }
      self._current = ncur!
      return ncur!.head
    }
    @inlinable
    func makeIterator() -> LLSeqIter {
      return LLSeqIter(self._current)
    }
  }
  @inlinable
  func makeIterator() -> LLSeqIter {
    return LLSeqIter(self)
  }
}

internal func makeCLUT() -> Array<UInt8> {
  var clut = Array(repeating: UInt8(0), count: 65536)
  for i in 0..<65536 {
    let v0 = ~i & 0xFFFF
    let v1 = v0 - ((v0 & 0xAAAA) >> 1)
    let v2 = (v1 & 0x3333) + ((v1 & 0xCCCC) >> 2)
    let v3 = (((((v2 & 0x0F0F) + ((v2 & 0xF0F0) >> 4)) &* 0x0101)) >> 8) & 31
    clut[i] = UInt8(v3)
  }
  return clut
}

internal let CLUT = makeCLUT()

internal func countComposites(_ cmpsts: SieveBuffer) -> Int {
  let len = cmpsts.count >> 1
  let clutp = UnsafePointer(CLUT) // for faster un-bounds checked access
  var bufp = UnsafeRawPointer(UnsafePointer(cmpsts))
                .assumingMemoryBound(to: UInt16.self)
  let plmt = bufp + len
  var count: Int = 0
  while (bufp < plmt) {
    count += Int(clutp[Int(bufp.pointee)])
    bufp += 1
  }
  return count
}

// converts an entire sieved array of bytes into an array of UInt32 primes,
// to be used as a source of base primes...
internal func composites2BasePrimeArray(_ low: BasePrime, _ cmpsts: SieveBuffer)
                                                          -> BasePrimeArray {
  let lmti = cmpsts.count << 3
  let len = countComposites(cmpsts)
  var rslt = BasePrimeArray(repeating: BasePrime(0), count: len)
  var j = 0
  for i in 0..<lmti {
    if (cmpsts[i >> 3] & (1 << (i & 7)) == UInt8(0)) {
      rslt[j] = low + BasePrime(i + i); j += 1
    }
  }
  return rslt
}

// do sieving work based on low starting value for the given buffer and
// the given lazy list of base prime arrays...
// uses pointers to avoid bounds checking for speed, but bounds are checked in code.
// uses an improved algorithm to maximize simple culling loop speed for
// the majority of cases of smaller base primes, only reverting to normal
// bit-packing operations for larger base primes...
// NOTE: a further optimization of maximum loop unrolling can later be
// implemented when warranted after maximum wheel factorization is implemented.
internal func sieveComposites(
      _ low: Prime, _ buf: SieveBuffer,
      _ bpas: LazyList<BasePrimeArray>) {
  let lowi = Int64((low - 3) >> 1)
  let len = buf.count
  let lmti = Int64(len << 3)
  let bufp = UnsafeMutablePointer(mutating: buf)
  let plen = bufp + len
  let nxti = lowi + lmti
  for bpa in bpas {
    for bp in bpa {
      let bp64 = Int64(bp)
      let bpi64 = (bp64 - 3) >> 1
      var strti = (bpi64 * (bpi64 + 3) << 1) + 3
      if (strti >= nxti) { return }
      if (strti >= lowi) { strti -= lowi }
      else {
        let r = (lowi - strti) % bp64
        strti = r == 0 ? 0 : bp64 - r
      }
      if (bp <= UInt32(len >> 3) && strti <= (lmti - 20 * bp64)) {
        let slmti = min(lmti, strti + (bp64 << 3))
        while (strti < slmti) {
          let msk = UInt8(1 << (strti & 7))
          var cp = bufp + Int(strti >> 3)
          while (cp < plen) {
              cp.pointee |= msk; cp += Int(bp64)
          }
          strti &+= bp64
        }
      }
      else {
        var c = strti
        let nbufp = UnsafeMutableRawPointer(bufp)
                      .assumingMemoryBound(to: Int32.self)
        while (c < lmti) {
            nbufp[Int(c >> 5)] |= 1 << (c & 31)
            c &+= bp64
        }
      }
    }
  }
}

// starts the secondary base primes feed with minimum size in bits set to 4K...
// thus, for the first buffer primes up to 8293,
// the seeded primes easily cover it as 97 squared is 9409...
// following used for fast clearing of SieveBuffer of multiple base size...
internal let clrbpseg = SieveBuffer(repeating: UInt8(0), count: 512)
internal func makeBasePrimeArrays() -> LazyList<BasePrimeArray> {
  var cmpsts = SieveBuffer(repeating: UInt8(0), count: 512)
  func nextelem(_ low: BasePrime, _ bpas: LazyList<BasePrimeArray>)
                                                -> LazyList<BasePrimeArray> {
    // calculate size so that the bit span is at least as big as the
    // maximum culling prime required, rounded up to minsizebits blocks...
    let rqdsz = 2 + Int(sqrt(Double(1 + low)))
    let sz = ((rqdsz >> 12) + 1) << 9 // size in bytes, blocks of 512 bytes
    if (sz > cmpsts.count) {
      cmpsts = SieveBuffer(repeating: UInt8(0), count: sz)
    }
    // fast clearing of the SieveBuffer array?
    for i in stride(from: 0, to: cmpsts.count, by: 512) {
      cmpsts.replaceSubrange(i..<i+512, with: clrbpseg)
    }
    sieveComposites(Prime(low), cmpsts, bpas)
    let arr = composites2BasePrimeArray(low, cmpsts)
    let nxt = low + BasePrime(cmpsts.count << 4)
    return LazyList(arr, { nextelem(nxt, bpas) })
  }
  // pre-seeding breaks recursive race,
  // as only known base primes used for first page...
  let preseedarr: [BasePrime] = [
    3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41
    , 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97 ]
  return
    LazyList(
      preseedarr,
      { nextelem(BasePrime(101), makeBasePrimeArrays()) })
}

// an iterable sequence over successive sieved buffer composite arrays,
// returning a tuple of the value represented by the lowest possible prime
// in the sieved composites array and the array itself;
// the array has a 16 Kilobytes minimum size (CPU L1 cache), but
// will grow so that the bit span is larger than the
// maximum culling base prime required, possibly making it larger than
// the L1 cache for large ranges, but still reasonably efficient using
// the L2 cache: very efficient up to about 16e9 range;
// reasonably efficient to about 2.56e14 for two Megabyte L2 cache = > 1 day...
internal let clrseg = SieveBuffer(repeating: UInt8(0), count: 16384)
func makeSievePages()
    -> UnfoldSequence<(Prime, SieveBuffer), ((Prime, SieveBuffer)?, Bool)> {
  let bpas = makeBasePrimeArrays()
  let cmpsts = SieveBuffer(repeating: UInt8(0), count: 16384)
  let low = Prime(3)
  sieveComposites(low, cmpsts, bpas)
  return sequence(first: (low, cmpsts), next: { (low, cmpsts) in
    var ncmpsts = cmpsts
    let rqdsz = 2 + Int(sqrt(Double(1 + low))) // problem with sqrt not exact past about 10^12!!!!!!!!!
    let sz = ((rqdsz >> 17) + 1) << 14 // size iin bytes, by chunks of 16384
    if (sz > ncmpsts.count) {
      ncmpsts = SieveBuffer(repeating: UInt8(0), count: sz)
    }
    // fast clearing of the SieveBuffer array?
    for i in stride(from: 0, to: ncmpsts.count, by: 16384) {
      ncmpsts.replaceSubrange(i..<i+16384, with: clrseg)
    }
    let nlow = low + Prime(ncmpsts.count << 4)
    sieveComposites(nlow, ncmpsts, bpas)
    return (nlow, ncmpsts)
  })
}

func countPrimesTo(_ range: Prime) -> Int64 {
  if (range < 3) { if (range < 2) { return Int64(0) }
                   else { return Int64(1) } }
  let rngi = Int64(range - 3) >> 1
  let clutp = UnsafePointer(CLUT) // for faster un-bounds checked access
  var count: Int64 = 1
  for sp in makeSievePages() {
    let (low, cmpsts) = sp; let lowi = Int64(low - 3) >> 1
    if ((lowi + Int64(cmpsts.count << 3)) > rngi) {
      let lsti = Int(rngi - lowi); let lstw = lsti >> 4
      let msk = UInt16(-2 << (lsti & 15))
      var bufp = UnsafeRawPointer(UnsafePointer(cmpsts))
                    .assumingMemoryBound(to: UInt16.self)
      let plmt = bufp + lstw
      while (bufp < plmt) {
        count += Int64(clutp[Int(bufp.pointee)]); bufp += 1
      }
      count += Int64(clutp[Int(bufp.pointee | msk)]);
      break;
    } else {
      count += Int64(countComposites(cmpsts))
    }
  }
  return count
}

// iterator of primes from the generated culled page segments...
struct PagedPrimesSeqIter: LazySequenceProtocol, IteratorProtocol {
  @inlinable
  init() {
    self._pgs = makeSievePages().makeIterator()
    self._cmpstsp = UnsafePointer(self._pgs.next()!.1)
  }
  @usableFromInline
  internal var _pgs: UnfoldSequence<(Prime, SieveBuffer), ((Prime, SieveBuffer)?, Bool)>
  @usableFromInline
  internal var _i = -2
  @usableFromInline
  internal var _low = Prime(3)
  @usableFromInline
  internal var _cmpstsp: UnsafePointer<UInt8>
  @usableFromInline
  internal var _lmt = 131072
  @inlinable
  mutating func next() -> Prime? {
    if self._i < -1 { self._i = -1; return Prime(2) }
    while true {
      repeat { self._i += 1 }
      while self._i < self._lmt &&
              (Int(self._cmpstsp[self._i >> 3]) & (1 << (self._i & 7))) != 0
      if self._i < self._lmt { break }
      let pg = self._pgs.next(); self._low = pg!.0
      let cmpsts = pg!.1; self._lmt = cmpsts.count << 3
      self._cmpstsp = UnsafePointer(cmpsts); self._i = -1
    }
    return self._low + Prime(self._i + self._i)
  }
  @inlinable
  func makeIterator() -> PagedPrimesSeqIter {
    return PagedPrimesSeqIter()
  }
  @inlinable
  var elements: PagedPrimesSeqIter {
    return PagedPrimesSeqIter()
  }
}

// sequence over primes using the above prime iterator from page iterator;
// unless doing something special with individual primes, usually unnecessary;
// better to do manipulations based on the composites bit arrays...
// takes at least as long to enumerate the primes as to sieve them...
func primesPaged() -> PagedPrimesSeqIter { return PagedPrimesSeqIter() }

let range = Prime(1000000000)

print("The first 25 primes are:")
primesPaged().prefix(25).forEach { print($0, "", terminator: "") }
print()

let start = NSDate()

let answr =
  countPrimesTo(range) // fast way, following enumeration way is slower...
//  primesPaged().prefix(while: { $0 <= range }).reduce(0, { a, _ in a + 1 })

let elpsd = -start.timeIntervalSinceNow

print("Found \(answr) primes up to \(range).")

print(String(format: "This test took %.3f milliseconds.", elpsd * 1000))
