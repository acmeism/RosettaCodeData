def fact(n) = n.zero? ? 1 :  1.upto(n).inject(&:*)

def lah(n, k)
  case k
    when 1 then fact(n)
    when n then 1
    when (..1),(n..) then 0
    else n<1 ? 0 : (fact(n)*fact(n-1)) / (fact(k)*fact(k-1)) / fact(n-k)
  end
end

r = (0..12)
puts "Unsigned Lah numbers: L(n, k):"
puts "n/k #{r.map{|n| "%11d" % n}.join}"

r.each do |row|
  print "%-4s" % row
  puts "#{(0..row).map{|col| "%11d" % lah(row,col)}.join}"
end

puts "\nMaximum value from the L(100, *) row:";
puts (1..100).map{|a| lah(100,a)}.max
