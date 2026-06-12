def three_adjacent_3s? (list)
  list.each_cons(3).count {|(a, b, c)|  a == b == c == 3 } == 1
end

[[9,3,3,3,2,1,7,8,5],
 [5,2,9,3,3,7,8,4,1],
 [1,4,3,6,7,3,8,3,2],
 [1,2,3,4,5,6,7,8,9],
 [4,6,8,7,2,3,3,3,1]].each do |list|
  puts "#{list} #{three_adjacent_3s?(list)}"
end
