def hailstone n
  seq = [n]
  until n == 1
    n = (n.even?) ? (n / 2) : (3 * n + 1)
    seq << n
  end
  seq
end

puts "for n = 27, show sequence length and first and last 4 elements"
hs27 = hailstone 27
p [hs27.length, hs27[0..3], hs27[-4..-1]]

# find the longest sequence among n less than 100,000
n = (1 ... 100_000).max_by{|n| hailstone(n).length}
puts "#{n} has a hailstone sequence length of #{hailstone(n).length}"
puts "the largest number in that sequence is #{hailstone(n).max}"
