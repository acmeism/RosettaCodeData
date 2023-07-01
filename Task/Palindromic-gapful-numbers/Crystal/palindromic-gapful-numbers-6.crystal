def palindromicgapfuls(digit, count, keep)
  palcnt = 0                        # count of gapful palindromes
  to_skip = count - keep            # count of unwanted values to skip
  gapfuls = [] of UInt64            # array of palindromic gapfuls
  dd, base = 11_u64 * digit, 1_u64  # digit gapful divisor: 11, 22,...88, 99
  (2..).select do |power|
    base   *= 10 if power.even?     # value of middle digit position: 10..
    base11  = base * 11             # value of middle two digits positions: 110..
    this_lo = base * digit          # starting half for this digit: 10.. to  90..
    next_lo = base * (digit + 1)    # starting half for next digit: 20.. to 100..
    this_lo.step(to: next_lo - 1, by: 10) do |front_half| # d_00; d_10; d_20; ...
      palindrome, left_half = 0_u64, front_half.to_s
      basep, right_half     = base11, left_half.reverse
      (basep = base; left_half = left_half.rchop) if power.even?
      palindrome = (left_half + right_half).to_u64
      10.times do
        gapfuls << palindrome if palindrome.divisible_by?(dd) && (palcnt += 1) > to_skip
        palindrome += basep
      end
      return gapfuls[0...keep] unless palcnt < count
    end
  end
end

start = Time.monotonic

count, keep = 20, 20
puts "First 20 palindromic gapful numbers ending with:"
1.upto(9) { |digit| puts "#{digit} : #{palindromicgapfuls(digit, count, keep)}" }

count, keep = 100, 15
puts "\nLast 15 of first 100 palindromic gapful numbers ending in:"
1.upto(9) { |digit| puts "#{digit} : #{palindromicgapfuls(digit, count, keep)}" }

count, keep = 1_000, 10
puts "\nLast 10 of first 1000 palindromic gapful numbers ending in:"
1.upto(9) { |digit| puts "#{digit} : #{palindromicgapfuls(digit, count, keep)}" }

count, keep = 100_000, 1
puts "\n100,000th palindromic gapful number ending with:"
1.upto(9) { |digit| puts "#{digit} : #{palindromicgapfuls(digit, count, keep)}" }

count, keep = 1_000_000, 1
puts "\n1,000,000th palindromic gapful number ending with:"
1.upto(9) { |digit| puts "#{digit} : #{palindromicgapfuls(digit, count, keep)}" }

count, keep = 10_000_000, 1
puts "\n10,000,000th palindromic gapful number ending with:"
1.upto(9) { |digit| puts "#{digit} : #{palindromicgapfuls(digit, count, keep)}" }

puts (Time.monotonic - start).total_seconds
