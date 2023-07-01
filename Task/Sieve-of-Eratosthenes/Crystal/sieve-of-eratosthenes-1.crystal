# compile with `--release --no-debug` for speed...

require "bit_array"

alias Prime = UInt64

class SoE
  include Iterator(Prime)
  @bits : BitArray; @bitndx : Int32 = 2

  def initialize(range : Prime)
    if range < 2
      @bits = BitArray.new 0
    else
      @bits = BitArray.new((range + 1).to_i32)
    end
    ba = @bits; ndx = 2
    while true
      wi = ndx * ndx
      break if wi >= ba.size
      if ba[ndx]
        ndx += 1; next
      end
      while wi < ba.size
        ba[wi] = true; wi += ndx
      end
      ndx += 1
    end
  end

  def next
    while @bitndx < @bits.size
      if @bits[@bitndx]
        @bitndx += 1; next
      end
      rslt = @bitndx.to_u64; @bitndx += 1; return rslt
    end
    stop
  end
end

print "Primes up to a hundred:  "
SoE.new(100).each { |p| print " ", p }; puts
print "Number of primes to a million:  "
puts SoE.new(1_000_000).each.size
print "Number of primes to a billion:  "
start_time = Time.monotonic
print SoE.new(1_000_000_000).each.size
elpsd = (Time.monotonic - start_time).total_milliseconds
puts " in #{elpsd} milliseconds."
