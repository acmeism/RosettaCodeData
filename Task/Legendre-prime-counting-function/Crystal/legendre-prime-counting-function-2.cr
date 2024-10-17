Tiny_Phi_Primes = [ 2, 3, 5, 7, 11, 13 ]
Tiny_Phi_Odd_Circ = Tiny_Phi_Primes.product // 2
Tiny_Phi_Tot = Tiny_Phi_Primes.reduce(1) { |acc, p| acc * (p - 1) }
CC = Tiny_Phi_Primes.size - 1
def make_Tiny_Phi_LUT()
  rslt = Array(UInt16).new(Tiny_Phi_Odd_Circ, 1_u16)
  Tiny_Phi_Primes.skip(1).each { |bp|
      i = (bp - 1) >> 1; rslt[i] = 0; c = (i + i) * (i + 1)
      while c < Tiny_Phi_Odd_Circ
        rslt[c] = 0; c += bp
      end }
  acc = 0_u16; i = 0
  while i < Tiny_Phi_Odd_Circ
    acc += rslt[i]; rslt[i] = acc; i += 1
  end
  rslt
end
Tiny_Phi_LUT = make_Tiny_Phi_LUT()
@[AlwaysInline]
def tiny_Phi(x : Int64) : Int64
  ndx = (x - 1) >> 1; numtot = ndx // Tiny_Phi_Odd_Circ.to_i64
  tpli = ndx - numtot * Tiny_Phi_Odd_Circ.to_i64
  numtot * Tiny_Phi_Tot.to_i64 +
    Tiny_Phi_LUT.unsafe_fetch(tpli).to_i64
end

def count_primes(n : Int64)
  if n < 169_i64 # below 169 whose sqrt is 13 is where TinyPhi doesn't work...
    return 0_i64 if n < 2_i64
    return 1_i64 if n < 3_i64
    # adjust for the missing "degree" base primes
    return 1 + (n - 1) // 2 if n < 9_i64
    return (n - 1) // 2 if n <= 13_i64
    return 5 + Tiny_Phi_LUT[(n - 1).to_i32 // 2].to_i64
  end
  rtlmt = Math.sqrt(n.to_f64).to_i32
  mxndx = (rtlmt - 3) // 2
  cmpsts = BitArray.new(mxndx + 1)
  i = 0
  while true
    c = (i + i) * (i + 3) + 3
    break if c > mxndx
    unless cmpsts[i]
      bp = i + i + 3
      until c > mxndx
        cmpsts[c] = true
        c += bp
      end
    end
    i += 1
  end
  oprms = Array(Int32).new(cmpsts.count { |e| !e }, 0)
  opi = 0
  cmpsts.each_with_index do |e, i|
    unless e
      oprms[opi] = (i + i + 3).to_i32; opi += 1
    end
  end
  lvl = uninitialized Proc(Int32, Int32, Int64, Int64) # recursion target!
  lvl = ->(pilo : Int32, pilmt : Int32, m : Int64) : Int64 {
    pi = pilo; answr = 0_i64
    while pi < pilmt
      p = oprms.unsafe_fetch(pi).to_i64; nm = p * m
      return answr + (pilmt - pi) if n <= nm * p
      q = (n.to_f64 / nm.to_f64).to_i64; answr += tiny_Phi(q)
      answr -= lvl.call(CC, pi, nm) if pi > CC
      pi += 1
    end
    answr
  }
  tiny_Phi(n) - lvl.call(CC, oprms.size, 1_i64) + oprms.size
end
