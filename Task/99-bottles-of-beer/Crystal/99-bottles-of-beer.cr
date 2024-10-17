99.downto(1) do |n|
  puts "#{n} bottle#{n > 1 ? "s" : ""} of beer on the wall"
  puts "#{n} bottle#{n > 1 ? "s" : ""} of beer"
  puts "Take one down, pass it around"
  puts "#{n-1} bottle#{n > 2 ? "s" : ""} of beer on the wall\n\n" if n > 1
end
puts "No more bottles of beer on the wall"
