from collections.vector import (DynamicVector, CollectionElement)
from math import (log2, trunc, pow)
from memory import memset_zero #, memcpy)
from time import now

alias cCOUNT: Int = 1_000_000

struct BigNat(Stringable): # enough just to support conversion and printing
  ''' Enough "infinite" precision to support as required here - multiply and
        divide by 10 conversion to string...
  '''
  var contents: DynamicVector[UInt32]
  fn __init__(inout self):
    self.contents = DynamicVector[UInt32]()
  fn __init__(inout self, val: UInt32):
    self.contents = DynamicVector[UInt32](4)
    self.contents.resize(1, val)
  fn __copyinit__(inout self, existing: Self):
    self.contents = existing.contents
  fn __moveinit__(inout self, owned existing: Self):
    self.contents = existing.contents^
  fn __str__(self) -> String:
    var rslt: String = ""
    var v = self.contents
    while len(v) > 0:
      var t: UInt64 = 0
      for i in range(len(v) - 1, -1, -1):
        t = ((t << 32) + v[i].to_int())
        v[i] = (t // 10).to_int(); t -= v[i].to_int() * 10
      var sz = len(v) - 1
      while sz >= 0 and v[sz] == 0: sz -= 1
      v.resize(sz + 1, 0)
      rslt = str(t) + rslt
    return rslt
  fn mult(inout self, mltplr: Self):
    var rslt = DynamicVector[UInt32]()
    rslt.resize(len(self.contents) + len(mltplr.contents), 0)
    for i in range(len(mltplr.contents)):
      var t: UInt64 = 0
      for j in range(len(self.contents)):
        t += self.contents[j].to_int() * mltplr.contents[i].to_int() + rslt[i + j].to_int()
        rslt[i + j] = (t & 0xFFFFFFFF).to_int(); t >>= 32
      rslt[i + len(self.contents)] += t.to_int()
    var sz = len(rslt) - 1
    while sz >= 0 and rslt[sz] == 0: sz -= 1
    rslt.resize(sz + 1, 0); self.contents = rslt

alias lb2: Float64 = 1.0
alias lb3: Float64 = log2[DType.float64, 1](3.0)
alias lb5: Float64 = log2[DType.float64, 1](5.0)

@value
struct LogRep(CollectionElement, Stringable):
  var logrep: Float64
  var x2: UInt32
  var x3: UInt32
  var x5: UInt32
  fn __del__(owned self): return
  @always_inline
  fn mul2(self) -> Self:
    return LogRep(self.logrep + lb2, self.x2 + 1, self.x3, self.x5)
  @always_inline
  fn mul3(self) -> Self:
    return LogRep(self.logrep + lb3, self.x2, self.x3 + 1, self.x5)
  @always_inline
  fn mul5(self) -> Self:
    return LogRep(self.logrep + lb5, self.x2, self.x3, self.x5 + 1)
  fn __str__(self) -> String:
    var rslt = BigNat(1)
    fn expnd(inout rslt: BigNat, bs: UInt32, n: UInt32):
      var bsm = BigNat(bs); var nm = n
      while nm > 0:
        if (nm & 1) != 0: rslt.mult(bsm)
        bsm.mult(bsm); nm >>= 1
    expnd(rslt, 2, self.x2); expnd(rslt, 3, self.x3); expnd(rslt, 5, self.x5)
    return str(rslt)

alias oneLR: LogRep = LogRep(0.0, 0, 0, 0)

alias LogRepThunk = fn() escaping -> LogRep

fn hammingsLogImp() -> LogRepThunk:
  var s2 = DynamicVector[LogRep](); var s3 = DynamicVector[LogRep](); var s5 = oneLR; var mrg = oneLR
  s2.resize(512, oneLR); s2[0] = oneLR.mul2(); s3.resize(1, oneLR); s3[0] = oneLR.mul3()
#  var s2p = s2.steal_data(); var s3p = s3.steal_data()
  var s2hdi = 0; var s2tli = -1; var s3hdi = 0; var s3tli = -1
  @always_inline
  fn next() escaping -> LogRep:
    var rslt = s2[s2hdi]
    var s2len = len(s2)
    s2tli += 1;
    if s2tli >= s2len:
      s2tli = 0
    if s2hdi == s2tli:
      if s2len < 1024:
        s2.resize(1024, oneLR)
      else:
        s2.resize(s2len + s2len, oneLR) # ; s2p = s2.steal_data()
        for i in range(s2hdi):
          s2[s2len + i] = s2[i]
#        memcpy[UInt8, 0](s2p + s2len, s2p, sizeof[LogRep]() * s2hdi)
        s2tli += s2len; s2len += s2len
    if rslt.logrep < mrg.logrep:
      s2hdi += 1
      if s2hdi >= s2len:
        s2hdi = 0
    else:
      rslt = mrg
      var s3len = len(s3)
      s3tli += 1;
      if s3tli >= s3len:
        s3tli = 0
      if s3hdi == s3tli:
        if s3len < 1024:
          s3.resize(1024, oneLR)
        else:
          s3.resize(s3len + s3len, oneLR) # ; s3p = s3.steal_data()
          for i in range(s3hdi):
            s3[s3len + i] = s3[i]
#          memcpy[UInt8, 0](s3p + s3len, s3p, sizeof[LogRep]() * s3hdi)
          s3tli += s3len; s3len += s3len
      if mrg.logrep < s5.logrep:
        s3hdi += 1
        if s3hdi >= s3len:
          s3hdi = 0
      else:
        s5 = s5.mul5()
      s3[s3tli] = rslt.mul3(); let t = s3[s3hdi];
      mrg = t if t.logrep < s5.logrep else s5
    s2[s2tli] = rslt.mul2(); return rslt
  return next

fn main():
  print("The first 20 Hamming numbers are:")
  var f = hammingsLogImp();
  for i in range(20): print_no_newline(f(), " ")
  print()
  f = hammingsLogImp(); var h: LogRep = oneLR
  for i in range(1691): h = f()
  print("The 1691st Hamming number is", h)
  let strt: Int = now()
  f = hammingsLogImp()
  for i in range(cCOUNT): h = f()
  let elpsd = (now() - strt) / 1000

  print("The " + str(cCOUNT) + "th Hamming number is:")
  print("2**" + str(h.x2) + " * 3**" + str(h.x3) + " * 5**" + str(h.x5))
  let lg2 = lb2 * Float64(h.x2.to_int()) + lb3 * Float64(h.x3.to_int()) + lb5 * Float64(h.x5.to_int())
  let lg10 = lg2 / log2(Float64(10))
  let expnt = trunc(lg10); let num = pow(Float64(10.0), lg10 - expnt)
  let apprxstr = str(num) + "E+" + str(expnt.to_int())
  print("Approximately: ", apprxstr)
  let answrstr = str(h)
  print("The result has", len(answrstr), "digits.")
  print(answrstr)
  print("This took " + str(elpsd) + " microseconds.")
