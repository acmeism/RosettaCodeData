require "bit_array"

def count_primes(n : Int64)
  if n < 3_i64
    return 0_i64 if n < 2_i64
    return 1_i64
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
  pi = 0
  cmpsts.each_with_index do |e, i|
    unless e
      oprms[pi] = (i + i + 3).to_i32; pi += 1
    end
  end
  phi = uninitialized Proc(Int64, Int32, Int64) # recursion target!
  phi = ->(x : Int64, a : Int32) {
    return x - (x >> 1) if a < 1
    p = oprms.unsafe_fetch(a - 1)
    return 1_i64 if x <= p
    phi.call(x, a - 1) - phi.call((x.to_f64 / p.to_f64).to_i64, a - 1)
  }
  phi.call(n, oprms.size) + oprms.size
end

start_time = Time.monotonic
(0 .. 9).each { |i| puts "π(10**#{i}) = #{count_primes(10_i64**i)}" }
elpsd = (Time.monotonic - start_time).total_milliseconds

puts "This took #{elpsd} milliseconds."
