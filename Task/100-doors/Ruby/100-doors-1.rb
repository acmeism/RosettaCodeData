doors = Array.new(101,0)
print "Open doors "
(1..100).step(){ |i|
(i..100).step(i) { |d|
    doors[d] = doors[d]^= 1
    if i == d and doors[d] == 1 then
      print "#{i} "
    end
  }
}
