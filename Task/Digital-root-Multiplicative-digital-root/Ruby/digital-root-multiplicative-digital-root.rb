def mdroot(n)
  mdr, persist = n, 0
  until mdr < 10 do
    mdr = mdr.digits.inject(:*)
    persist += 1
  end
  [mdr, persist]
end

puts "Number: MDR  MP", "======  ===  =="
[123321, 7739, 893, 899998].each{|n| puts "%6d:   %d  %2d" % [n, *mdroot(n)]}

counter = Hash.new{|h,k| h[k]=[]}
0.step do |i|
  counter[mdroot(i).first] << i
  break if counter.values.all?{|v| v.size >= 5 }
end
puts "", "MDR: [n0..n4]", "===  ========"
10.times{|i| puts "%3d: %p" % [i, counter[i].first(5)]}
