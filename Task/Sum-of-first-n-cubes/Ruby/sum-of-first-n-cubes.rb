sum = 0
(0...50).each do |n|
  print (sum += n**3).to_s.ljust(10)
  puts "" if (n+1) % 10 == 0
end
