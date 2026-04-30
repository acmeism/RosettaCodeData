# since there are 8 possible places to split the 123456789 string,
# we can map each to a bit in a byte and split if the bit is 1
def split_digits (pattern)
  result = [] of Int32
  number = 1
  (2..9).each do |digit|
    if pattern.odd?
      result << number
      number = 0
    end
    number = number * 10 + digit
    pattern >>= 1
  end
  result << number
end

sums = Hash(Int32, Int32).new(0)

puts "Sum to 100:"
(0_u8..255_u8).each do |pattern|
  numbers = split_digits(pattern)
  Indexable.each_cartesian([[1, -1]] * numbers.size) do |mults|
    sum = numbers.zip(mults).sum {|n, m| n * m }
    sums[sum] += 1
    if sum == 100
      puts numbers.zip(mults).map {|n, m| (m == 1 ? "+" : "-") + n.to_s }.join
    end
  end
end
puts
print "Positive sum with maximum number of solutions: "
puts "%d (%d solutions)" % sums.select {|k, _| k >= 0 }.max_by {|_, v| v}
puts
print "Lowest positive sum that can't be expressed: "
puts (0..).find {|i| !sums.has_key? i }
puts
puts "Ten highest sums: #{sums.keys.max(10)}"
