// compile with:  v -cflags -march=native -cflags -O3 -prod HammingsLog.v

import time
import math.big
import math { log2, sqrt, pow, floor }

const num_elements = 1_000_000

struct LogRep {
  lg big.Integer
  x2 u32
  x3 u32
  x5 u32
}
const (
  one = LogRep { big.zero_int, 0, 0, 0 }
  // 1267650600228229401496703205376
  lb2_2 = big.Integer { digits: [u32(0), 0, 0, 16],
                        signum: 1, is_const: true }
  // 2009178665378409109047848542368
  lb2_3 = big.Integer { digits: [u32(11608224), 3177740794, 1543611295, 25]
	                    signum: 1, is_const: true }
  // 2943393543170754072109742145491
  lb2_5 = big.Integer { digits: [u32(1258143699), 1189265298, 647893747, 37],
                        signum: 1, is_const: true }
  smlb2_2 = f64(1.0)
  smlb2_3 = log2(3.0)
  smlb2_5 = log2(5.0)
  fctr = f64(6.0) * smlb2_3 * smlb2_5
  crctn = log2(sqrt(30.0))
)
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
fn (lr LogRep) to_integer() big.Integer {
  return xpnd(lr.x2, 2) * xpnd(lr.x3, 3) * xpnd(lr.x5, 5)
}
fn (lr LogRep) str() string {
  return lr.to_integer().str()
}

fn nth_hamming_log(n u64) LogRep {
  if n < 2 { return one }
  lgest := pow(fctr * f64(n), f64(1.0)/f64(3.0)) - crctn // from WP formula
  frctn := if n < 1_000_000_000 { f64(0.509) } else { f64(0.105) }
  lghi := pow(fctr * (f64(n) + frctn * lgest), f64(1.0)/f64(3.0)) - crctn
  lglo := f64(2.0) * lgest - lghi // and a lower limit of the upper "band"
  mut count := u64(0) // need to use extended precision, might go over
  mut band := []LogRep { len: 1, cap: 1 } // give it one value so doubling size works
  mut ih := 0 // band array insertion index
  klmt := u32(lghi / smlb2_5) + 1
  for k in u32(0) .. klmt {
    p := f64(k) * smlb2_5
    jlmt := u32((lghi - p) / smlb2_3) + 1
    for j in u32(0) .. jlmt {
      q := p + f64(j) * smlb2_3
      ir := lghi - q
      lg := q + floor(ir) // current log value (estimated)
      count += u64(ir) + 1
      if lg >= lglo {
        len := band.len
        if ih >= len { unsafe { band.grow_len(len) } }
        bglg := lb2_2 * big.integer_from_u32(u32(ir)) +
                  lb2_3 * big.integer_from_u32(j) +
                  lb2_5 * big.integer_from_u32(k)
        band[ih] = LogRep { lg: bglg, x2: u32(ir), x3: j, x5: k }
        ih++
      }
    }
  }
  band.sort_with_compare(fn(a &LogRep, b &LogRep) int {
      return b.lg.abs_cmp(a.lg)
    }
  )
  if n > count { panic("nth_hamming_log: band high estimate is too low!") }
  ndx := int(count - n)
  if ndx >= band.len { panic("nth_hamming_log: band low estimate is too high!") }
  return band[ndx]
}

for i in 1 .. 21 { print("${nth_hamming_log(i)} ") }
println("")

println("${nth_hamming_log(1691)}")

start_time := time.now()
rslt := nth_hamming_log(num_elements)
duration := (time.now() - start_time).microseconds()
println("$rslt")
println("Above result for $num_elements elements in $duration microseconds.")
