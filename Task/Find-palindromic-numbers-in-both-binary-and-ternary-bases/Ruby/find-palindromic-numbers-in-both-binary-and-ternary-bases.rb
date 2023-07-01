pal23 = Enumerator.new do |y|
  y << 0
  y << 1
  for i in 1 .. 1.0/0.0                 # 1.step do |i|  (Ruby 2.1+)
    n3 = i.to_s(3)
    n = (n3 + "1" + n3.reverse).to_i(3)
    n2 = n.to_s(2)
    y << n  if n2.size.odd? and n2 == n2.reverse
  end
end

puts "         decimal          ternary                          binary"
6.times do |i|
  n = pal23.next
  puts "%2d: %12d %s %s" % [i, n, n.to_s(3).center(25), n.to_s(2).center(39)]
end
