(2..8).each do |d|
  rep = d.to_s * d
  print "#{d}: "
  puts (2..).lazy.select{|n| (d * n**d).to_s.include?(rep) }.first(10).join(", ")
end
