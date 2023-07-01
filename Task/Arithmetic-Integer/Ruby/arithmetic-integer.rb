puts 'Enter x and y'
x = gets.to_i  # to check errors, use x=Integer(gets)
y = gets.to_i

puts "Sum: #{x+y}",
     "Difference: #{x-y}",
     "Product: #{x*y}",
     "Quotient: #{x/y}",       # truncates towards negative infinity
     "Quotient: #{x.fdiv(y)}", # float
     "Remainder: #{x%y}",      # same sign as second operand
     "Exponentiation: #{x**y}",
     "Quotient: %d with Remainder: %d" % x.divmod(y)
