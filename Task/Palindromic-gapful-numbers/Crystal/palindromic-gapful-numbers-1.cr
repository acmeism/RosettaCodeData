def palindromesgapful(digit, pow)
  r1 = (10_u64**pow + 1) * digit
  r2 = 10_u64**pow * (digit + 1)
  nn = digit * 11
  (r1...r2).select { |i| n = i.to_s; n == n.reverse && i.divisible_by?(nn) }
end

def digitscount(digit, count)
  pow  = 2
  nums = [] of UInt64
  while nums.size < count
    nums += palindromesgapful(digit, pow)
    pow += 1
  end
  nums[0...count]
end

count = 20
puts "First 20 palindromic gapful numbers ending with:"
(1..9).each { |digit| print "#{digit} : #{digitscount(digit, count)}\n" }

count = 100
puts "\nLast 15 of first 100 palindromic gapful numbers ending in:"
(1..9).each { |digit| print "#{digit} : #{digitscount(digit, count).last(15)}\n" }

count = 1000
puts "\nLast 10 of first 1000 palindromic gapful numbers ending in:"
(1..9).each { |digit| print "#{digit} : #{digitscount(digit, count).last(10)}\n" }
