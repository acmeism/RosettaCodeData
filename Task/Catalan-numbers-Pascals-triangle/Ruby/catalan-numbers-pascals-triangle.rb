def catalan(num)
  t = [0, 1] #grows as needed
  1.upto(num).map do |i|
    i.downto(1){|j| t[j] += t[j-1]}
    t[i+1] = t[i]
    (i+1).downto(1) {|j| t[j] += t[j-1]}
    t[i+1] - t[i]
  end
end

puts catalan(15).join(", ")
