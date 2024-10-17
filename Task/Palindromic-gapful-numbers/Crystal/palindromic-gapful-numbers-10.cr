class PalNo
  @digit : UInt64
  @dd : UInt64

  def initialize(digit : Int32)
    @digit, @l, @dd = digit.to_u64, 3, 11u64 * digit
  end

  def fN(n : Int32)
    return [0, 1, 2, 3, 4, 5, 6, 7, 8, 9] of UInt64 if n == 1
    return [0, 11, 22, 33, 44, 55, 66, 77, 88, 99] of UInt64 if n == 2
    a = [] of UInt64
    ([0, 1, 2, 3, 4, 5, 6, 7, 8, 9] of UInt64).product(fN(n - 2)) do |g0, g1|
      a << g0.to_u64 &* 10u64 &** (n - 1) &+ g0.to_u64 &+ 10u64 &* g1.to_u64
    end
    return a
  end

  def show(count, keep)
    to_skip, palcnt, pals = count - keep, 0, [] of UInt64
    while palcnt < count
      fN(@l - 2).each do |g|
        pal = @digit * 10u64 &** (@l - 1) + @digit + 10u64 &* g
        pals << pal if pal % @dd == 0 && (palcnt += 1) > to_skip
        break if palcnt - to_skip == keep
      end
      @l += 1
    end
    print pals; puts
  end
end

start = Time.monotonic

(1..9).each { |digit| PalNo.new(digit).show(20, 20) }; puts "####"
(1..9).each { |digit| PalNo.new(digit).show(100, 15) }; puts "####"
(1..9).each { |digit| PalNo.new(digit).show(1000, 10) }; puts "####"
(1..9).each { |digit| PalNo.new(digit).show(100_000, 1) }; puts "####"
(1..9).each { |digit| PalNo.new(digit).show(1_000_000, 1) }; puts "####"
(1..9).each { |digit| PalNo.new(digit).show(10_000_000, 1) }; puts "####"

puts (Time.monotonic - start).total_seconds
