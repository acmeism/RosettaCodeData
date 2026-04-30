struct Int
  def mdr
    n, p = self, 0
    return {0, 0} unless n > 0
    while n >= 10
      n = n.digits.product
      p += 1
    end
    { n, p }
  end
end

puts <<-EOH
   n   MDR MP
-------------
EOH
[123321, 7739, 893, 899998].each do |n|
  printf "%6d  %d  %d\n", n, *n.mdr
end
puts
puts <<-EOH
MDR: [n0..n4]
===  ========
EOH
buckets = Array(Array(Int32)).new(10) { [] of Int32 }
(0..).each do |n|
  mdr, _ = n.mdr
  buckets[mdr] << n
  break if buckets.all? {|b| b.size >= 5 }
end
buckets.each_with_index do |b, i|
  printf "%3d: %s\n", i, b.first(5)
end
