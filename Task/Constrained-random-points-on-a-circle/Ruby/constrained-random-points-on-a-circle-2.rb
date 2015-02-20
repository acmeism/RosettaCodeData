r2 = 10*10..15*15
range = (-15..15).to_a
points = range.product(range).each_with_object([]) do |(i,j), pt|
  pt << [i,j] if r2.cover?(i*i + j*j)
end

puts "Precalculate: #{points.size}"
pt = Hash.new("  ")
points.sample(100).each{|i,j| pt[[i,j]] = " o"}
puts range.map{|i| range.map{|j| pt[[i,j]]}.join}
