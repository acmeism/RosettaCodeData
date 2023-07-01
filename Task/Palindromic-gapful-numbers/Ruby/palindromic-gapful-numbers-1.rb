def palindromesgapful(digit, pow)
  r1 = digit * (10**pow + 1)
  r2 = 10**pow * (digit + 1)
  nn = digit * 11
  (r1...r2).select { |i| n = i.to_s; n == n.reverse && i % nn == 0 }
end

def digitscount(digit, count)
  pow  = 2
  nums = []
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
