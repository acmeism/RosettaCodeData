n = 0
counter = Hash.new(0)
inventory = loop.lazy.map do
    c = counter[n]
    counter[c] += 1
    c == 0 ? n = 0 : n += 1
    c
 end
 inventory.first(100).each_slice(10){|s| puts "%4d"*s.size % s}
 puts

 (1000..10000).step(1000).each do |t|
   n = 0
   counter.clear
   puts "First element >= #{t} : %d index %d" % inventory.with_index.detect{|e,i| e > t}
 end
