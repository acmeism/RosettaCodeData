h = []
["north", "east", "south", "west", "north"].each_cons(2) do |a, b|
  c = if ["north", "south"].include? a then "#{a}#{b}" else "#{b}#{a}" end
  h << a
  h << "#{a} by #{b}"
  h << "#{a}-#{c}"
  h << "#{c} by #{a}"
  h << "#{c}"
  h << "#{c} by #{b}"
  h << "#{b}-#{c}"
  h << "#{b} by #{a}"
end

puts "Headings = {"
h.each_with_index { |n, i| puts "  #{i+1} => #{n.inspect}," }
puts "}"
