n = 100
(1..n).each do |i|
  puts "Door #{i} is #{i**0.5 == (i**0.5).round ? "open" : "closed"}"
end
