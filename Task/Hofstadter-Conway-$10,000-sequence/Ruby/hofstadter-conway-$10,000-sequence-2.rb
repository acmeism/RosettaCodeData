p = -1
20.downto(1).each_cons(2) do |j, i|
  max_n, max_v = -1, -1
  (2**j).downto(2**i).each do |n|
    v = hc[n].to_f / n
    max_n, max_v = n, v if v > max_v
    # Mallows number
    p = n if p == -1 and v >= 0.55
  end
  puts "maximum between 2^#{i} and 2^#{j} occurs at #{max_n}: #{max_v}"
end

puts "the mallows number is #{p}"
