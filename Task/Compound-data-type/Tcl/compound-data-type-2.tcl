set point [dict create x 4 y 5]
dict set point y 7
puts "Point is {[dict get $point x],[dict get $point y]}"
