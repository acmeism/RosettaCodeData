r2 = 10*10..15*15
range = (-15..15).to_a
points = range.product(range).select {|i,j| r2.cover?(i*i + j*j)}

puts "Precalculate: #{points.size}"
pt = Hash.new("  ")
points.sample(100).each{|ij| pt[ij] = " o"}
puts range.map{|i| range.map{|j| pt[[i,j]]}.join}
