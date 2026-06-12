require "big"

k = 1
to_find = (0..50).to_set
results = Array.new(51, 0)
until to_find.empty?
  str = (k.to_big_i ** k).to_s
  to_find.reject! {|n|
    if n.to_s.in? str
      results[n] = k
    end
  }
  k += 1
end

puts "Smallest values of k such that k^k contains n:"
results.each_with_index do |k, i|
  printf "%2d → %-2d   %s", i, k, (i+1)%9 == 0 ? "\n" : ""
end
