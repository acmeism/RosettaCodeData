require "date"

puts d1 = DateTime.parse("March 7 2009 7:30pm EST")
# d1 + 1 would add a day, so add half a day:
puts d2 = d1 + 1/2r # 1/2r is a rational; 0.5 would also work
puts d3 = d2.new_offset('+09:00')
