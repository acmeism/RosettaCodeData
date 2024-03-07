from memory import memset_zero
from memory.unsafe import (DTypePointer)
from time import (now)

alias cLIMIT: Int = 1_000_000_000

struct SoEBasic(Sized):
    var len: Int
    var cmpsts: DTypePointer[DType.bool] # because DynamicVector has deep copy bug in mojo version 0.7
    var sz: Int
    var ndx: Int
    fn __init__(inout self, limit: Int):
        self.len = limit - 1
        self.sz = limit - 1
        self.ndx = 0
        self.cmpsts = DTypePointer[DType.bool].alloc(limit - 1)
        memset_zero(self.cmpsts, limit - 1)
        for i in range(limit - 1):
            let s = i * (i + 4) + 2
            if s >= limit - 1: break
            if self.cmpsts[i]: continue
            let bp = i + 2
            for c in range(s, limit - 1, bp):
                self.cmpsts[c] = True
        for i in range(limit - 1):
            if self.cmpsts[i]: self.sz -= 1
    fn __del__(owned self):
        self.cmpsts.free()
    fn __copyinit__(inout self, existing: Self):
        self.len = existing.len
        self.cmpsts = DTypePointer[DType.bool].alloc(self.len)
        for i in range(self.len):
            self.cmpsts[i] = existing.cmpsts[i]
        self.sz = existing.sz
        self.ndx = existing.ndx
    fn __moveinit__(inout self, owned existing: Self):
        self.len = existing.len
        self.cmpsts = existing.cmpsts
        self.sz = existing.sz
        self.ndx = existing.ndx
    fn __len__(self: Self) -> Int: return self.sz
    fn __iter__(self: Self) -> Self: return self
    fn __next__(inout self: Self) -> Int:
        if self.ndx >= self.len: return 0
        while (self.ndx < self.len) and (self.cmpsts[self.ndx]):
            self.ndx += 1
        let rslt = self.ndx + 2; self.sz -= 1; self.ndx += 1
        return rslt

fn main():
    print("The primes to 100 are:")
    for prm in SoEBasic(100): print_no_newline(prm, " ")
    print()
    let strt0 = now()
    let answr0 = len(SoEBasic(1_000_000))
    let elpsd0 = (now() - strt0) / 1000000
    print("Found", answr0, "primes up to 1,000,000 in", elpsd0, "milliseconds.")
    let strt1 = now()
    let answr1 = len(SoEBasic(cLIMIT))
    let elpsd1 = (now() - strt1) / 1000000
    print("Found", answr1, "primes up to", cLIMIT, "in", elpsd1, "milliseconds.")
