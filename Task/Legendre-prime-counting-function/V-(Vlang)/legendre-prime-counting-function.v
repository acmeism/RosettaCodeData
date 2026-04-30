// can compile with:  v -cflags -march=native -cflags -O3 -prod MagicCount.v
import time
import math { sqrt }

const masks = [ u8(1), 2, 4, 8, 16, 32, 64, 128 ] // faster than bit twiddling!

@[inline]
fn half(n u64) i64 { return i64((n - 1) >>> 1) } // convenience function!

@[inline] // floating point divide faster than integer divide!
fn divide(nm u64, d u64) u64 { return u64(f64(nm) / f64(d)) }

@[direct_array_access]
fn count_primes_to(n u64) i64 {
  if n < u64(9) { return if n < i64(2) { i64(0) } else { i64((n + 1) / 2) } }
  rtlmt := u64(sqrt(f64(n)))
  mxndx := i64((rtlmt - 1) / 2)
  arrlen := int(mxndx + 1)
  mut smalls := []u32{ len: arrlen, cap: arrlen, init: u32(index) }
  mut roughs := []u32{ len: arrlen, cap: arrlen, init: u32(index + index + 1) }
  mut larges := []i64{ len: arrlen, cap: arrlen,
                       init: i64(((n / u64(index + index + 1) - 1) / 2)) }
  cullbuflen := int((mxndx + 8) / 8)
  mut cullbuf := []u8{len: cullbuflen, cap: cullbuflen, init: u8(0)}
  mut nbps := i64(0) // do partial sieving for each odd base prime to quad root...
  mut rilmt := arrlen // number of roughs start with full size!
  // start with 3; breaks when partial sieving done...
  for i := i64(1); ; i++ {
    sqri := (i + i) * (i + 1)
    if sqri > mxndx { break } // breaks here!
    if (cullbuf[i >>> 3] & masks[i & 7]) != u8(0) { continue } // not prime!
    cullbuf[i >>> 3] |= masks[i & 7] // cull bp rep!
    bp := u64(i + i + 1) // partial sieve by bp...
    for c := sqri; c < arrlen; c += i64(bp) { cullbuf[c >>> 3] |= masks[c & 7] }
    mut nri := 0 // transfer from `ori` to `nri` indexes:
	// update `roughs` and `larges` for partial sieve...
    for ori in 0 .. rilmt {
      r := roughs[ori]
      rci := i64(r >>> 1) // skip recently culled in last partial sieve...
      if (cullbuf[rci >>> 3] & masks[rci & 7]) != u8(0) { continue }
      d := u64(r) * u64(bp)
      larges[nri] = larges[ori] -
                    (if d <= rtlmt { larges[i64(smalls[d >>> 1]) - nbps] }
                     else { i64(smalls[half(divide(n, d))]) })
                     + nbps // adjust for over subtraction of base primes!
      roughs[nri] = r // compress for culled `larges` and `roughs`!
      nri++ // advance output `roughs` index!
    }
    mut si := mxndx // update `smalls` for partial sieve...
    for pm := ((rtlmt / bp) - 1) | 1; pm >= bp; pm -= 2 {
      c := smalls[pm >>> 1]
      e := (pm * bp) >>> 1
      for ; si >= e; si-- { smalls[si] -= (c - u32(nbps)) }
    }
    rilmt = nri // new rough size limit!
    nbps++ // for one partial sieve base prime pass!
  }
  // combine results so far; adjust for over subtraction of base prime count...
  mut ans := larges[0] + i64(((rilmt + 2 * (nbps - 1)) * (rilmt - 1) / 2))
  for ri in 1 .. rilmt { ans -= larges[ri] } // combine results so far!
  // add quotient for product of pairs of primes, quad root to cube root...
  // break controlled below
  for ri := 1; ; ri++ {
    p := u64(roughs[ri])
    m := n / p
    ei := int(smalls[half(u64(m / p))]) - nbps
    if ei <= ri { break } // break out when only multiple equal to `p`
    ans -= i64((ei - ri) * (nbps + ri - 1)) // adjust for over addition below!
    // add for products of 1st and 2nd primes...
    for sri in ri + 1 .. ei + 1 {
      ans += i64(smalls[half(divide(m, u64(roughs[sri])))]) }
  }
  return ans + 1 // add one for only even prime of two!
}

start_time := time.now()
mut pow := u64(1)
for i in 0 .. 10 {
  println("π(10**$i) = ${count_primes_to(pow)}")
  pow *= 10 }
duration := (time.now() - start_time).milliseconds()
println("This took $duration milliseconds.")
