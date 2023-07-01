# compile with `--release --no-debug` for speed...

require "bit_array"

alias Prime = UInt64

class SoE_Odds
  include Iterator(Prime)
  @bits : BitArray; @bitndx : Int32 = -1

  def initialize(range : Prime)
    if range < 3
      @bits = BitArray.new 0
    else
      @bits = BitArray.new(((range - 1) >> 1).to_i32)
    end
    ba = @bits; ndx = 0
    while true
      wi = (ndx + ndx) * (ndx + 3) + 3 # start cull index calculation
      break if wi >= ba.size
      if ba[ndx]
        ndx += 1; next
      end
      bp = ndx + ndx + 3
      while wi < ba.size
        ba[wi] = true; wi += bp
      end
      ndx += 1
    end
  end

  def next
    while @bitndx < @bits.size
      if @bitndx < 0
        @bitndx += 1; return 2_u64
      elsif @bits[@bitndx]
        @bitndx += 1; next
      end
      rslt = (@bitndx + @bitndx + 3).to_u64; @bitndx += 1; return rslt
    end
    stop
  end
end

print "Primes up to a hundred:  "
SoE_Odds.new(100).each { |p| print " ", p }; puts
print "Number of primes to a million:  "
puts SoE_Odds.new(1_000_000).each.size
print "Number of primes to a billion:  "
start_time = Time.monotonic
print SoE_Odds.new(1_000_000_000).each.size
elpsd = (Time.monotonic - start_time).total_milliseconds
puts " in #{elpsd} milliseconds."
