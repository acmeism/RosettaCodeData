// compile with:  v -cflags -march=native -cflags -O3 -prod HammingsLogQ.v

import time
import math.big
import math { log2 }
import arrays { copy }

const num_elements = 1_000_000

struct LogRep {
  lg f64
  x2 u32
  x3 u32
  x5 u32
}
const (
  one = LogRep { 0.0, 0, 0, 0 }
  lb2_2 = 1.0
  lb2_3 = log2(3.0)
  lb2_5 = log2(5.0)
)
[inline]
fn (lr &LogRep) mul2() LogRep {
  return LogRep { lg: lr.lg + lb2_2,
                  x2: lr.x2 + 1,
                  x3: lr.x3,
                  x5: lr.x5 }
}
[inline]
fn (lr &LogRep) mul3() LogRep {
  return LogRep { lg: lr.lg + lb2_3,
                  x2: lr.x2,
                  x3: lr.x3 + 1,
                  x5: lr.x5 }
}
[inline]
fn (lr &LogRep) mul5() LogRep {
  return LogRep { lg: lr.lg + lb2_5,
                  x2: lr.x2,
                  x3: lr.x3,
                  x5: lr.x5 + 1 }
}
[inline]
fn xpnd(x u32, mlt u32) big.Integer {
  mut r := big.integer_from_int(1)
  mut m := big.integer_from_u32(mlt)
  mut v := x
  for {
    if v <= 0 { break }
    else {
      if v & 1 != 0 { r = r * m }
      m = m * m
      v >>= 1
    }
  }
  return r
}
fn (lr &LogRep) to_integer() big.Integer {
  return xpnd(lr.x2, 2) * xpnd(lr.x3, 3) * xpnd(lr.x5, 5)
}
fn (lr LogRep) str() string {
  return (&lr).to_integer().str()
}

struct HammingsLog {
    mut:
    // automatically initialized with LogRep = one (defult)...
    s2 []LogRep = []LogRep { len: 1024, cap: 1024 }
    s3 []LogRep = []LogRep { len: 1024, cap: 1024 }
    s5 LogRep = one.mul5()
    mrg LogRep = one.mul3()
    s2msk int = 1023
    s2hdi int
    s2nxti int = 1
    s3msk int = 1023
    s3hdi int
    s3nxti int
}
[direct_array_access][inline]
fn (mut hl HammingsLog) next() ?LogRep {
  mut rsltp := &hl.s2[hl.s2hdi]
  if rsltp.lg < hl.mrg.lg {
    hl.s2[hl.s2nxti] = rsltp.mul2()
    hl.s2hdi++
    hl.s2hdi &= hl.s2msk
  } else {
    mut rslt := hl.mrg
    rsltp = &rslt
    hl.s2[hl.s2nxti] = hl.mrg.mul2()
    hl.s3[hl.s3nxti] = hl.mrg.mul3()
    s3hdp := &hl.s3[hl.s3hdi]
    if unsafe { s3hdp.lg < hl.s5.lg } {
      hl.mrg = *s3hdp
      hl.s3hdi++
      hl.s3hdi &= hl.s3msk
    } else {
      hl.mrg = hl.s5
      hl.s5 = hl.s5.mul5()
    }
    hl.s3nxti++
    hl.s3nxti &= hl.s3msk
    if hl.s3nxti == hl.s3hdi { // buffer full: grow it
      sz := hl.s3msk + 1
      hl.s3msk = sz + sz
      unsafe { hl.s3.grow_len(sz) }
      hl.s3msk--
      if hl.s3hdi == 0 {
        hl.s3nxti = sz
      } else {
        unsafe { vmemcpy(&hl.s3[hl.s3hdi + sz], &hl.s3[hl.s3hdi],
                         int(sizeof(LogRep)) * (sz - hl.s3hdi)) }
        hl.s3hdi += sz
      }
    }
  }
  hl.s2nxti++
  hl.s2nxti &= hl.s2msk
  if hl.s2nxti == hl.s2hdi { // buffer full: grow it
    sz := hl.s2msk + 1
    hl.s2msk = sz + sz
    unsafe { hl.s2.grow_len(sz) }
    hl.s2msk--
    if hl.s2hdi == 0 {
      hl.s2nxti = sz
    } else {
      unsafe { vmemcpy(&hl.s2[hl.s2hdi + sz], &hl.s2[hl.s2hdi],
                       int(sizeof(LogRep)) * (sz - hl.s2hdi)) }
      hl.s2hdi += sz
    }
  }
  return *rsltp
}

fn (hmgs HammingsLog) nth_hammings_log(n int) LogRep {
  mut cnt := 0
  if n > 0 { for h in hmgs {
               cnt++
               if cnt >= n { return h } }
  }
  panic("argument less than 1 for nth!")
}

{
  hs := HammingsLog {}
  mut cnt := 0
  for h in hs {
    print("$h ")
    cnt++
    if cnt >= 20 { break }
  }
  println("")
}

println("${(HammingsLog{}).nth_hammings_log(1691)}")

start_time := time.now()
rslt := (HammingsLog{}).nth_hammings_log(num_elements)
duration := (time.now() - start_time).microseconds()
println("$rslt")
println("Above result for $num_elements elements in $duration microseconds.")
