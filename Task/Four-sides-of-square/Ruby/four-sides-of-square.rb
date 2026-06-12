def square_sides(size = 9)
  Array.new(size){|n| n==0 || n==size-1 ? [1]*size : [1]+[0]*(size-2)+[1]}
end

puts square_sides.map{|line| line.join (" ") }
