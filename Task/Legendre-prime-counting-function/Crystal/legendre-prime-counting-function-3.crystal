def count_primes(n : Int64) : Int64
  if n < 3
    if n < 2
      return 0_i64
    else
      return 1_i64
    end
  end
  half = ->(n : Int64) : Int64 { (n - 1) >> 1 }
  divide = ->(n : Int64, d : Int64) : Int64 { (n.to_f64 / d.to_f64).to_i64 }
  rtlmt = Math.sqrt(n.to_f64).to_i32; mxndx = (rtlmt - 1) // 2
  cmpsts = BitArray.new(mxndx + 1)
  smalls = Array(Int32).new(mxndx + 1) { |i| i }
  roughs = Array(Int32).new(mxndx + 1) { |i| i + i + 1 }
  larges =
    Array(Int64).new(mxndx + 1) { |i| ((n // (i + i + 1)).to_i64 - 1) >> 1 }
  i = 1; nbps = 0; mxri = mxndx
  while true
    c = (i + i) * (i + 1); break if c > mxndx
    if !cmpsts.unsafe_fetch(i)
      bp = i + i + 1; cmpsts.unsafe_put(i, true)
      until c > mxndx
        cmpsts.unsafe_put(c, true); c += bp
      end # partial sieving for bp completed here!

      j = 0; ri = 0 # adjust `larges` according to partial sieve...
      while j <= mxri
        q = roughs.unsafe_fetch(j); qi = q >> 1
        if !cmpsts.unsafe_fetch(qi)
          d = bp.to_i64 * q.to_i64
          larges.unsafe_put(ri, larges.unsafe_fetch(j) -
                                  if d <= rtlmt.to_i64
                                    ndx = smalls.unsafe_fetch(d >> 1) - nbps
                                    larges.unsafe_fetch(ndx)
                                  else
                                    ndx = half.call(divide.call(n, d))
                                    smalls.unsafe_fetch(ndx)
                                  end + nbps)
          roughs.unsafe_put(ri, q); ri += 1
        end; j += 1
      end

      si = mxndx; bpm = (rtlmt // bp - 1) | 1
      while bpm >= bp # adjust smalls according to partial sieve...
        c = smalls.unsafe_fetch(bpm >> 1) - nbps; e = (bpm * bp) >> 1
        while si >= e
          smalls.unsafe_put(si, smalls.unsafe_fetch(si) - c); si -= 1
        end
        bpm -= 2
      end

      mxri = ri - 1; nbps += 1
    end; i += 1
  end

  ans = larges.unsafe_fetch(0); i = 1
  while i <= mxri # combine results; adjust for over subtraction base primes...
    ans -= larges.unsafe_fetch(i); i += 1
  end
  ans += (mxri.to_i64 + 1 + 2 * (nbps.to_i64 - 1)) * mxri.to_i64 // 2 # adjust!

  ri = 1 # do final phi calculation for pairs of larger primes...
  while true # break on condition when up to cube root of range!
    p = roughs.unsafe_fetch(ri).to_i64; q = n // p
    e = smalls.unsafe_fetch(half.call(divide.call(q, p))) - nbps
    break if e <= ri; ori = ri + 1
    while ori <= e
      ndx = half.call(divide.call(q, roughs.unsafe_fetch(ori).to_i64))
      ans += smalls.unsafe_fetch(ndx).to_i64; ori += 1
    end
    ans -= (e - ri).to_i64 * (nbps.to_i64 + ri.to_i64 - 1); ri += 1
  end

  ans + 1 # for only even prime of two!
end
