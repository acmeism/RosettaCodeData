@memo = {}

def sterling2(n, k)
  key = [n,k]
  return @memo[key] if @memo.key?(key)
  return 1 if n.zero? and k.zero?
  return 0 if n.zero? or  k.zero?
  return 1 if n == k
  return 0 if k > n
  res = k * sterling2(n-1, k) + sterling2(n - 1, k-1)
  @memo[key] = res
end

r = (0..12)
puts "Sterling2 numbers:"
puts "n/k #{r.map{|n| "%11d" % n}.join}"

r.each do |row|
  print "%-4s" % row
  puts "#{(0..row).map{|col| "%11d" % sterling2(row, col)}.join}"
end

puts "\nMaximum value from the sterling2(100, k)";
puts (1..100).map{|a| sterling2(100,a)}.max
