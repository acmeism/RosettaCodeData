print "Enter a string: "
s = gets
printf "Enter an integer: "
i = gets.to_i   # If string entered, will return zero
printf "Enter a real number: "
f = Float(gets) rescue nil   # converts a floating point number or returns nil
puts "String  = #{s}"
puts "Integer = #{i}"
puts "Float   = #{f}"
