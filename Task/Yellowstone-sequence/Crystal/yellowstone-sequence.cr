def yellowstone
  used = Set(Int32).new
  penult, last = 2, 3
  start = 4
  iter = Iterator.of do
    while start.in? used
      used.delete start
      start += 1
    end
    (start..).each do |n|
      if !used.includes?(n) && n.gcd(last) == 1 && n.gcd(penult) > 1
        used << n
        penult, last = last, n
        break n
      end
    end
  end
  (1..3).each.chain iter
end

p yellowstone.first(30).to_a

values = yellowstone.first(100).to_a
height = (values.max - 1) // 8

(0..height).reverse_each do |i|
  values.each do |v|
    d = v - i*8
    print d <= 0 ? ' ' : d >= 8 ? '█' : '\u2580' + d
  end
  puts
end
