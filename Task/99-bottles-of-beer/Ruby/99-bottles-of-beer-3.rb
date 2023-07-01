def bottles(of_beer, ending)
  puts "#{of_beer} bottle#{ending} of beer on the wall,"
  puts "#{of_beer} bottle#{ending} of beer"
  puts "Take one down, pass it around!"
end

99.downto(0) do |left|
  if left > 1
    bottles(left, "s")
  elsif left == 1
    bottles(left, "")
  else
    puts "No more bottles of beer on the wall!"
  end
end
