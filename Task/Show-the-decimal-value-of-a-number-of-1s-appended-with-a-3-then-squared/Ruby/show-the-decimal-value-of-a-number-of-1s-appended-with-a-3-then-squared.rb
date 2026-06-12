m = 8
(0..m).each do |n|
  ones3 = "1"*n +"3"
  puts ones3.ljust(m+2) + ( ones3.to_i**2).to_s
end
