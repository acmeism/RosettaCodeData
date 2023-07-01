str, e = "e = Rset.new", nil
puts "#{str} -> #{eval(str)}\t\t# create empty set"
str = "e.empty?"
puts "#{str} -> #{eval(str)}"
puts

include Math
lohi = Enumerator.new do |y|
  t = 1 / sqrt(6)
  0.step do |n|
    y << [sqrt(12*n+1) * t, sqrt(12*n+5) * t]
    y << [sqrt(12*n+7) * t, sqrt(12*n+11) * t]
  end
end

a = Rset.new
loop do
  lo, hi = lohi.next
  break  if 10 <= lo
  a |= Rset(lo, hi)
end
a &= Rset(0,10)

b = (0...10).inject(Rset.new){|res,i| res |= Rset(i+1/6r,i+5/6r)}

puts "a        : #{a}"
puts "a.length : #{a.length}"
puts "b        : #{b}"
puts "b.length : #{b.length}"
puts "a - b    : #{a - b}"
puts "(a-b).length : #{(a-b).length}"
