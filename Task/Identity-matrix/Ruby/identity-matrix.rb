def identity(size)
  size.times.map { |i| size.times.map { |j| i == j ? 1 : 0 } }
end

[4,5,6].each do |size|
  puts size, identity(size.to_i).map {|r| r.to_s}, ""
end
