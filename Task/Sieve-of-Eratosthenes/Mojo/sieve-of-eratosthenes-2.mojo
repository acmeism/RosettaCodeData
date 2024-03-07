from memory import (memset_zero, memcpy)
from memory.unsafe import (DTypePointer)
from math.bit import ctpop
from time import (now)

alias cLIMIT: Int = 1_000_000_000

alias cBufferSize: Int = 262144 # bytes
alias cBufferBits: Int = cBufferSize * 8

alias UnrollFunc = fn(DTypePointer[DType.uint8], Int, Int, Int) -> None

@always_inline
fn extreme[OFST: Int, BP: Int](pcmps: DTypePointer[DType.uint8], bufsz: Int, s: Int, bp: Int):
  var cp = pcmps + (s >> 3)
  let r1: Int = ((s + bp) >> 3) - (s >> 3)
  let r2: Int = ((s + 2 * bp) >> 3) - (s >> 3)
  let r3: Int = ((s + 3 * bp) >> 3) - (s >> 3)
  let r4: Int = ((s + 4 * bp) >> 3) - (s >> 3)
  let r5: Int = ((s + 5 * bp) >> 3) - (s >> 3)
  let r6: Int = ((s + 6 * bp) >> 3) - (s >> 3)
  let r7: Int = ((s + 7 * bp) >> 3) - (s >> 3)
  let plmt: DTypePointer[DType.uint8] = pcmps + bufsz - r7
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
  let eplmt: DTypePointer[DType.uint8] = plmt + r7
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

fn mkExtrm[CNT: Int](pntr: Pointer[UnrollFunc]):
  @parameter
  if CNT >= 32:
    return
  alias OFST = CNT >> 2
  alias BP = ((CNT & 3) << 1) + 1
  pntr.offset(CNT).store(extreme[OFST, BP])
  mkExtrm[CNT + 1](pntr)

@always_inline
fn mkExtremeFuncs() -> Pointer[UnrollFunc]:
  let jmptbl: Pointer[UnrollFunc] = Pointer[UnrollFunc].alloc(32)
  mkExtrm[0](jmptbl)
  return jmptbl

let extremeFuncs = mkExtremeFuncs()

alias DenseFunc = fn(DTypePointer[DType.uint64], Int, Int) -> DTypePointer[DType.uint64]

fn mkDenseCull[N: Int, BP: Int](cp: DTypePointer[DType.uint64]):
  @parameter
  if N >= 64:
    return
  alias MUL = N * BP
  var cop = cp.offset(MUL >> 6)
  cop.store(cop.load() | (1 << (MUL & 63)))
  mkDenseCull[N + 1, BP](cp)

@always_inline
fn denseCullFunc[BP: Int](pcmps: DTypePointer[DType.uint64], bufsz: Int, s: Int) -> DTypePointer[DType.uint64]:
  var cp: DTypePointer[DType.uint64] = pcmps + (s >> 6)
  let plmt = pcmps + (bufsz >> 3) - BP
  while cp < plmt:
    mkDenseCull[0, BP](cp)
    cp += BP
  return cp

fn mkDenseFunc[CNT: Int](pntr: Pointer[DenseFunc]):
  @parameter
  if CNT >= 64:
    return
  alias BP = (CNT << 1) + 3
  pntr.offset(CNT).store(denseCullFunc[BP])
  mkDenseFunc[CNT + 1](pntr)

@always_inline
fn mkDenseFuncs() -> Pointer[DenseFunc]:
  let jmptbl : Pointer[DenseFunc] = Pointer[DenseFunc].alloc(64)
  mkDenseFunc[0](jmptbl)
  return jmptbl

let denseFuncs : Pointer[DenseFunc] = mkDenseFuncs()

@always_inline
fn cullPass(cmpsts: DTypePointer[DType.uint8], bytesz: Int, s: Int, bp: Int):
    if bp <= 129: # dense culling
        var sm = s
        while (sm >> 3) < bytesz and (sm & 63) != 0:
            cmpsts[sm >> 3] |= (1 << (sm & 7))
            sm += bp
        let bcp = denseFuncs[(bp - 3) >> 1](cmpsts.bitcast[DType.uint64](), bytesz, sm)
        var ns = 0
        var ncp = bcp
        let cmpstslmtp = (cmpsts + bytesz).bitcast[DType.uint64]()
        while ncp < cmpstslmtp:
            ncp[0] |= (1 << (ns & 63))
            ns += bp
            ncp = bcp + (ns >> 6)
    else: # extreme loop unrolling culling
        extremeFuncs[((s & 7) << 2) + ((bp & 7) >> 1)](cmpsts, bytesz, s, bp)
#    for c in range(s, self.len, bp): # slow bit twiddling way
#        self.cmpsts[c >> 3] |= (1 << (c & 7))

fn countPagePrimes(ptr: DTypePointer[DType.uint8], bitsz: Int) -> Int:
    let wordsz: Int = (bitsz + 63) // 64  # round up to nearest 64 bit boundary
    var rslt: Int = wordsz * 64
    let bigcmps = ptr.bitcast[DType.uint64]()
    for i in range(wordsz - 1):
       rslt -= ctpop(bigcmps[i]).to_int()
    rslt -= ctpop(bigcmps[wordsz - 1] | (-2 << ((bitsz - 1) & 63))).to_int()
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
        let bytesz = 0 if limit < 2 else ((self.len + 63) & -64) >> 3 # round up to nearest 64 bit boundary
        self.cmpsts = DTypePointer[DType.uint8].alloc(bytesz)
        memset_zero(self.cmpsts, bytesz)
        for i in range(self.len):
            let s = (i + i) * (i + 3) + 3
            if s >= self.len: break
            if (self.cmpsts[i >> 3] >> (i & 7)) & 1 != 0: continue
            let bp = i + i + 3
            cullPass(self.cmpsts, bytesz, s, bp)
        self.sz = countPagePrimes(self.cmpsts, self.len) + 1 # add one for only even prime of two
    fn __del__(owned self):
        self.cmpsts.free()
    fn __copyinit__(inout self, existing: Self):
        self.len = existing.len
        let bytesz = (self.len + 7) // 8
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
        let rslt = (self.ndx << 1) + 3; self.sz -= 1; self.ndx += 1; return rslt

fn main():
    print("The primes to 100 are:")
    for prm in SoEOdds(100): print_no_newline(prm, " ")
    print()
    let strt0 = now()
    let answr0 = len(SoEOdds(1_000_000))
    let elpsd0 = (now() - strt0) / 1000000
    print("Found", answr0, "primes up to 1,000,000 in", elpsd0, "milliseconds.")
    let strt1 = now()
    let answr1 = len(SoEOdds(cLIMIT))
    let elpsd1 = (now() - strt1) / 1000000
    print("Found", answr1, "primes up to", cLIMIT, "in", elpsd1, "milliseconds.")
