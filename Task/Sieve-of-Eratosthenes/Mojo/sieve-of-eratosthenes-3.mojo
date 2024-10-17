from memory import (memset_zero, memcpy)
from memory.unsafe import (DTypePointer)
from bit import pop_count
from time import (now)

alias cLIMIT: Int = 1_000_000_000

alias cBufferSize: Int = 262144 # bytes
alias cBufferBits: Int = cBufferSize * 8

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
    var t: UInt64 =  r + q
    r >>= 1
    if x >= t:
      x -= t; r += q
  return r

alias UnrollFunc = fn(DTypePointer[DType.uint8], Int, Int, Int) -> None

@always_inline
fn extreme[OFST: Int, BP: Int](pcmps: DTypePointer[DType.uint8], bufsz: Int, s: Int, bp: Int):
  var cp = pcmps + (s >> 3)
  var r1: Int = ((s + bp) >> 3) - (s >> 3)
  var r2: Int = ((s + 2 * bp) >> 3) - (s >> 3)
  var r3: Int = ((s + 3 * bp) >> 3) - (s >> 3)
  var r4: Int = ((s + 4 * bp) >> 3) - (s >> 3)
  var r5: Int = ((s + 5 * bp) >> 3) - (s >> 3)
  var r6: Int = ((s + 6 * bp) >> 3) - (s >> 3)
  var r7: Int = ((s + 7 * bp) >> 3) - (s >> 3)
  var plmt: DTypePointer[DType.uint8] = pcmps + bufsz - r7
  while cp < plmt:
    cp.store(cp.load() | (1 << OFST))
    (cp + r1).store((cp + r1).load() | (1 << ((OFST + BP) & 7)))
    (cp + r2).store((cp + r2).load() | (1 << ((OFST + 2 * BP) & 7)))
    (cp + r3).store((cp + r3).load() | (1 << ((OFST + 3 * BP) & 7)))
    (cp + r4).store((cp + r4).load() | (1 << ((OFST + 4 * BP) & 7)))
    (cp + r5).store((cp + r5).load() | (1 << ((OFST + 5 * BP) & 7)))
    (cp + r6).store((cp + r6).load() | (1 << ((OFST + 6 * BP) & 7)))
    (cp + r7).store((cp + r7).load() | (1 << ((OFST + 7 * BP) & 7)))
    cp += bp
  var eplmt: DTypePointer[DType.uint8] = plmt + r7
  if eplmt == cp or eplmt < cp: return
  cp.store(cp.load() | (1 << OFST))
  cp += r1
  if eplmt == cp or eplmt < cp: return
  cp.store(cp.load() | (1 << ((OFST + BP) & 7)))
  cp += r2 - r1
  if eplmt == cp or eplmt < cp: return
  cp.store(cp.load() | (1 << ((OFST + 2 * BP) & 7)))
  cp += r3 - r2
  if eplmt == cp or eplmt < cp: return
  cp.store(cp.load() | (1 << ((OFST + 3 * BP) & 7)))
  cp += r4 - r3
  if eplmt == cp or eplmt < cp: return
  cp.store(cp.load() | (1 << ((OFST + 4 * BP) & 7)))
  cp += r5 - r4
  if eplmt == cp or eplmt < cp: return
  cp.store(cp.load() | (1 << ((OFST + 5 * BP) & 7)))
  cp += r6 - r5
  if eplmt == cp or eplmt < cp: return
  cp.store(cp.load() | (1 << ((OFST + 6 * BP) & 7)))
  cp += r7 - r6
  if eplmt == cp or eplmt < cp: return
  cp.store(cp.load() | (1 << ((OFST + 7 * BP) & 7)))

fn mkExtremeFuncs[SIZE: Int]() -> UnsafePointer[UnrollFunc, 0]:
  var jmptbl = UnsafePointer[UnrollFunc, 0].alloc(SIZE)
  @parameter
  for i in range(SIZE):
    alias OFST = i >> 2
    alias BP = ((i & 3) << 1) + 1
    jmptbl[i] = extreme[OFST, BP]
  return jmptbl

alias DenseFunc = fn(DTypePointer[DType.uint64], Int, Int) -> DTypePointer[DType.uint64]

@always_inline
fn denseCullFunc[BP: Int](pcmps: DTypePointer[DType.uint64], bufsz: Int, s: Int) -> DTypePointer[DType.uint64]:
  var cp: DTypePointer[DType.uint64] = pcmps + (s >> 6)
  var plmt = pcmps + (bufsz >> 3) - BP
  while cp < plmt:
    @parameter
    for n in range(64):
      alias MUL = n * BP
      var cop = cp.offset(MUL >> 6)
      cop.store(cop.load() | (1 << (MUL & 63)))
    cp += BP
  return cp

fn mkDenseFuncs[SIZE: Int]() -> UnsafePointer[DenseFunc, 0]:
  var jmptbl = UnsafePointer[DenseFunc, 0].alloc(SIZE)
  @parameter
  for i in range(SIZE):
    alias BP = (i << 1) + 3
    jmptbl[i] = denseCullFunc[BP]
  return jmptbl

@always_inline
fn cullPass(dfs: UnsafePointer[DenseFunc, 0], efs: UnsafePointer[UnrollFunc, 0],
            cmpsts: DTypePointer[DType.uint8], bytesz: Int, s: Int, bp: Int):
    if bp <= 129: # dense culling
        var sm = s
        while (sm >> 3) < bytesz and (sm & 63) != 0:
            cmpsts[sm >> 3] |= (1 << (sm & 7))
            sm += bp
        var bcp = dfs[(bp - 3) >> 1](cmpsts.bitcast[DType.uint64](), bytesz, sm)
        var ns = 0
        var ncp = bcp
        var cmpstslmtp = (cmpsts + bytesz).bitcast[DType.uint64]()
        while ncp < cmpstslmtp:
            ncp[0] |= (1 << (ns & 63))
            ns += bp
            ncp = bcp + (ns >> 6)
    else: # extreme loop unrolling culling
        efs[((s & 7) << 2) + ((bp & 7) >> 1)](cmpsts, bytesz, s, bp)
#    for c in range(s, bytesz * 8, bp): # slow bit twiddling way
#        cmpsts[c >> 3] |= (1 << (c & 7))

fn cullPage(dfs: UnsafePointer[DenseFunc, 0], efs: UnsafePointer[UnrollFunc, 0],
            lwi: Int, lmt: Int, cmpsts: DTypePointer[DType.uint8], bsprmrps: DTypePointer[DType.uint8]):
    var bp = 1; var ndx = 0
    while True:
        bp += int(bsprmrps[ndx]) << 1
        var i = (bp - 3) >> 1
        var s = (i + i) * (i + 3) + 3
        if s >= lmt: break
        if s >= lwi: s -= lwi
        else:
            s = (lwi - s) % bp
            if s != 0: s = bp - s
        cullPass(dfs, efs, cmpsts, cBufferSize, s, bp)
        ndx += 1

fn countPagePrimes(ptr: DTypePointer[DType.uint8], bitsz: Int) -> Int:
    var wordsz: Int = (bitsz + 63) // 64  # round up to nearest 64 bit boundary
    var rslt: Int = wordsz * 64
    var bigcmps = ptr.bitcast[DType.uint64]()
    for i in range(wordsz - 1):
       rslt -= int(pop_count(bigcmps[i]))
    rslt -= int(pop_count(bigcmps[wordsz - 1] | (-2 << ((bitsz - 1) & 63))))
    return rslt

struct SoEOdds(Sized):
    var len: Int
    var cmpsts: DTypePointer[DType.uint8] # because DynamicVector has deep copy bug in Mojo version 0.7
    var sz: Int
    var ndx: Int
    fn __init__(inout self, limit: Int):
        self.len = 0 if limit < 2 else (limit - 3) // 2 + 1
        self.sz = 0 if limit < 2 else self.len + 1 # for the unprocessed only even prime of two
        self.ndx = -1
        var bytesz = 0 if limit < 2 else ((self.len + 63) & -64) >> 3 # round up to nearest 64 bit boundary
        self.cmpsts = DTypePointer[DType.uint8].alloc(bytesz)
        memset_zero(self.cmpsts, bytesz)
        var denseFuncs : UnsafePointer[DenseFunc, 0] = mkDenseFuncs[64]()
        var extremeFuncs: UnsafePointer[UnrollFunc, 0] = mkExtremeFuncs[32]()
        for i in range(self.len):
            var s = (i + i) * (i + 3) + 3
            if s >= self.len: break
            if (self.cmpsts[i >> 3] >> (i & 7)) & 1 != 0: continue
            var bp = i + i + 3
            cullPass(denseFuncs, extremeFuncs, self.cmpsts, bytesz, s, bp)
        self.sz = countPagePrimes(self.cmpsts, self.len) + 1 # add one for only even prime of two
    fn __del__(owned self):
        self.cmpsts.free()
    fn __copyinit__(inout self, existing: Self):
        self.len = existing.len
        var bytesz = (self.len + 7) // 8
        self.cmpsts = DTypePointer[DType.uint8].alloc(bytesz)
        memcpy(self.cmpsts, existing.cmpsts, bytesz)
        self.sz = existing.sz
        self.ndx = existing.ndx
    fn __moveinit__(inout self, owned existing: Self):
        self.len = existing.len
        self.cmpsts = existing.cmpsts
        self.sz = existing.sz
        self.ndx = existing.ndx
    fn __len__(self: Self) -> Int: return self.sz
    fn __iter__(self: Self) -> Self: return self
    @always_inline
    fn __next__(inout self: Self) -> Int:
        if self.ndx < 0:
            self.ndx = 0; self.sz -= 1; return 2
        while (self.ndx < self.len) and ((self.cmpsts[self.ndx >> 3] >> (self.ndx & 7)) & 1 != 0):
            self.ndx += 1
        var rslt = (self.ndx << 1) + 3; self.sz -= 1; self.ndx += 1; return rslt

struct SoEOddsPaged:
    var denseFuncs : UnsafePointer[DenseFunc, 0]
    var extremeFuncs: UnsafePointer[UnrollFunc, 0]
    var len: Int
    var cmpsts: DTypePointer[DType.uint8] # because DynamicVector has deep copy bug in Mojo version 0.7
    var sz: Int # 0 means finished; otherwise contains number of odd base primes
    var ndx: Int
    var lwi: Int
    var bsprmrps: DTypePointer[DType.uint8] # contains deltas between odd base primes starting from zero
    fn __init__(inout self, limit: UInt64):
        self.denseFuncs = mkDenseFuncs[64]()
        self.extremeFuncs = mkExtremeFuncs[32]()
        self.len = 0 if limit < 2 else int(((limit - 3) // 2 + 1))
        self.sz = 0 if limit < 2 else 1 # means iterate until this is set to zero
        self.ndx = -1 # for unprocessed only even prime of two
        self.lwi = 0
        if self.len < cBufferBits:
            var bytesz = ((self.len + 63) & -64) >> 3 # round up to nearest 64 bit boundary
            self.cmpsts = DTypePointer[DType.uint8].alloc(bytesz)
            self.bsprmrps = DTypePointer[DType.uint8].alloc(self.sz)
        else:
            self.cmpsts = DTypePointer[DType.uint8].alloc(cBufferSize)
            var bsprmitr = SoEOdds(int(intsqrt(limit)))
            self.sz = len(bsprmitr)
            self.bsprmrps = DTypePointer[DType.uint8].alloc(self.sz)
            var ndx = -1; var oldbp = 1
            for bsprm in bsprmitr:
                if ndx < 0: ndx += 1; continue # skip over the 2 prime
                self.bsprmrps[ndx] = (bsprm - oldbp) >> 1
                oldbp = bsprm; ndx += 1
            self.bsprmrps[ndx] = 255 # one extra value to go beyond the necessary cull space
    fn __del__(owned self):
        self.cmpsts.free(); self.bsprmrps.free()
    fn __copyinit__(inout self, existing: Self):
        self.denseFuncs = existing.denseFuncs
        self.extremeFuncs = existing.extremeFuncs
        self.len = existing.len
        self.sz = existing.sz
        var bytesz = cBufferSize if self.len >= cBufferBits
                     else ((self.len + 63) & -64) >> 3 # round up to nearest 64 bit boundary
        self.cmpsts = DTypePointer[DType.uint8].alloc(bytesz)
        memcpy(self.cmpsts, existing.cmpsts, bytesz)
        self.ndx = existing.ndx
        self.lwi = existing.lwi
        self.bsprmrps = DTypePointer[DType.uint8].alloc(self.sz)
        memcpy(self.bsprmrps, existing.bsprmrps, self.sz)
    fn __moveinit__(inout self, owned existing: Self):
        self.denseFuncs = existing.denseFuncs
        self.extremeFuncs = existing.extremeFuncs
        self.len = existing.len
        self.cmpsts = existing.cmpsts
        self.sz = existing.sz
        self.ndx = existing.ndx
        self.lwi = existing.lwi
        self.bsprmrps = existing.bsprmrps
    fn countPrimes(self) -> Int:
        if self.len <= cBufferBits: return len(SoEOdds(2 * self.len + 1))
        var cnt = 1; var lwi = 0
        var cmpsts = DTypePointer[DType.uint8].alloc(cBufferSize)
        memset_zero(cmpsts, cBufferSize)
        cullPage(self.denseFuncs, self.extremeFuncs, 0, cBufferBits, cmpsts, self.bsprmrps)
        while lwi + cBufferBits <= self.len:
            cnt += countPagePrimes(cmpsts, cBufferBits)
            lwi += cBufferBits
            memset_zero(cmpsts, cBufferSize)
            var lmt = lwi + cBufferBits if lwi + cBufferBits <= self.len else self.len
            cullPage(self.denseFuncs, self.extremeFuncs, lwi, lmt, cmpsts, self.bsprmrps)
        cnt += countPagePrimes(cmpsts, self.len - lwi)
        return cnt
    fn __len__(self: Self) -> Int: return self.sz
    fn __iter__(self: Self) -> Self: return self
    @always_inline
    fn __next__(inout self: Self) -> Int: # don't count number of primes by interating - slooow
        if self.ndx < 0:
            self.ndx = 0; self.lwi = 0
            if self.len < 2: self.sz = 0
            elif self.len <= cBufferBits:
                var bytesz = ((self.len + 63) & -64) >> 3 # round up to nearest 64 bit boundary
                memset_zero(self.cmpsts, bytesz)
                for i in range(self.len):
                    var s = (i + i) * (i + 3) + 3
                    if s >= self.len: break
                    if (self.cmpsts[i >> 3] >> (i & 7)) & 1 != 0: continue
                    var bp = i + i + 3
                    cullPass(self.denseFuncs, self.extremeFuncs, self.cmpsts, bytesz, s, bp)
            else:
                memset_zero(self.cmpsts, cBufferSize)
                cullPage(self.denseFuncs, self.extremeFuncs, 0, cBufferBits, self.cmpsts, self.bsprmrps)
            return 2
        var rslt = ((self.lwi + self.ndx) << 1) + 3; self.ndx += 1
        if self.lwi + cBufferBits >= self.len:
            while (self.lwi + self.ndx < self.len) and ((self.cmpsts[self.ndx >> 3] >> (self.ndx & 7)) & 1 != 0):
                self.ndx += 1
        else:
            while (self.ndx < cBufferBits) and ((self.cmpsts[self.ndx >> 3] >> (self.ndx & 7)) & 1 != 0):
                self.ndx += 1
            while (self.ndx >= cBufferBits) and (self.lwi + cBufferBits <= self.len):
                self.ndx = 0; self.lwi += cBufferBits; memset_zero(self.cmpsts, cBufferSize)
                var lmt = self.lwi + cBufferBits if self.lwi + cBufferBits <= self.len else self.len
                cullPage(self.denseFuncs, self.extremeFuncs, self.lwi, lmt, self.cmpsts, self.bsprmrps)
                var buflmt = cBufferBits if self.lwi + cBufferBits <= self.len else self.len - self.lwi
                while (self.ndx < buflmt) and ((self.cmpsts[self.ndx >> 3] >> (self.ndx & 7)) & 1 != 0):
                    self.ndx += 1
        if self.lwi + self.ndx >= self.len: self.sz = 0
        return rslt

fn main():
    print("The primes to 100 are:")
    for prm in SoEOddsPaged(100): print(prm, " ", end="")
    print()
    var strt0 = now()
    var answr0 = SoEOddsPaged(1_000_000).countPrimes()
    var elpsd0 = (now() - strt0) / 1000000
    print("Found", answr0, "primes up to 1,000,000 in", elpsd0, "milliseconds.")
    var strt1 = now()
    var answr1 = SoEOddsPaged(cLIMIT).countPrimes()
    var elpsd1 = (now() - strt1) / 1000000
    print("Found", answr1, "primes up to", cLIMIT, "in", elpsd1, "milliseconds.")
