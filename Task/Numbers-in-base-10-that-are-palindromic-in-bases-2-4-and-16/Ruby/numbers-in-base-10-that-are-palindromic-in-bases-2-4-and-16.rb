res = (0..25000).select do |n|
  [2, 4, 16].all? do |base|
    b = n.to_s(base)
    b == b.reverse
  end
end
puts res.join(" ")
