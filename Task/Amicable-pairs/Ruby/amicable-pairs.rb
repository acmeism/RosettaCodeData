h = {}
(1..20_000).each{|n| h[n] = n.proper_divisors.sum }
h.select{|k,v| h[v] == k && k < v}.each do |key,val|  # k<v filters out doubles and perfects
  puts "#{key} and #{val}"
end
