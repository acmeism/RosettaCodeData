struct PalindromicGapfuls
    include Enumerable(UInt64)

    @dd : Int32

    def initialize(@digit : Int32)
      @dd = 11 * @digit                 # digit gapful divisor: 11, 22,...88, 99
    end

    def each
      (2..).select do |power|
        base    = 10_u64**(power >> 1)  # value of middle digit position: 10..
        base11  = base * 11             # value of middle two digits positions: 110..
        this_lo = base * @digit         # starting half for this digit: 10.. to  90..
        next_lo = base * (@digit + 1)   # starting half for next digit: 20.. to 100..
        this_lo.step(to: next_lo - 1, by: 10) do |front_half| # d_00; d_10; d_20; ...
          basep = power.odd? ? base11 : base
          palindrome = make_palindrome(front_half, power)
          10.times do
            yield palindrome if palindrome.divisible_by?(@dd)
            palindrome += basep
          end
        end
      end
    end

    # Optimized output method: only keep desired values.
    def keep_from(count, keep)
      to_skip = (count - keep)
      kept = [] of UInt64
      each_with_index do |value, i|
        i < to_skip ? next : kept << value
        return kept if kept.size == keep
      end
    end

    def make_palindrome(front_half, power)
      result = front_half
      result //= 10 if power.even?
      while front_half > 0
        result = result * 10 + front_half.remainder(10)
        front_half //= 10
      end
      result
    end
  end

  start = Time.monotonic

  count, keep = 20, 20
  puts "First 20 palindromic gapful numbers ending with:"
  1.upto(9) { |digit| puts "#{digit} : #{PalindromicGapfuls.new(digit).keep_from(count, keep)}" }

  count, keep = 100, 15
  puts "\nLast 15 of first 100 palindromic gapful numbers ending in:"
  1.upto(9) { |digit| puts "#{digit} : #{PalindromicGapfuls.new(digit).keep_from(count, keep)}" }

  count, keep = 1_000, 10
  puts "\nLast 10 of first 1000 palindromic gapful numbers ending in:"
  1.upto(9) { |digit| puts "#{digit} : #{PalindromicGapfuls.new(digit).keep_from(count, keep)}" }

  count, keep = 100_000, 1
  puts "\n100,000th palindromic gapful number ending with:"
  1.upto(9) { |digit| puts "#{digit} : #{PalindromicGapfuls.new(digit).keep_from(count, keep)}" }

  count, keep = 1_000_000, 1
  puts "\n1,000,000th palindromic gapful number ending with:"
  1.upto(9) { |digit| puts "#{digit} : #{PalindromicGapfuls.new(digit).keep_from(count, keep)}" }

  count, keep = 10_000_000, 1
  puts "\n10,000,000th palindromic gapful number ending with:"
  1.upto(9) { |digit| puts "#{digit} : #{PalindromicGapfuls.new(digit).keep_from(count, keep)}" }

  puts (Time.monotonic - start).total_seconds
