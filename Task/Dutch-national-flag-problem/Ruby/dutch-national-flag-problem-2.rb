balls = nil
while balls.nil? or balls.dutch? do
  balls = Dutch::Balls.random 8
end
puts "Start: #{balls}"
puts "Sorted: #{balls.dutch}"
puts "Intact: #{balls}"
puts "In-place: #{balls.dutch!}"
puts "Modified: #{balls}"
