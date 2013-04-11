a = (print "enter a value for a: "; gets).to_i
b = (print "enter a value for b: "; gets).to_i

case a <=> b
when -1; puts "#{a} is less than #{b}"
when  0; puts "#{a} is equal to #{b}"
when +1; puts "#{a} is greater than #{b}"
end
