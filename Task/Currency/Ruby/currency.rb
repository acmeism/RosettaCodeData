require 'bigdecimal/util'

before_tax = 4000000000000000 * 5.50.to_d + 2 * 2.86.to_d
tax        = (before_tax * 0.0765.to_d).round(2)
total      = before_tax + tax

puts "Before tax: $#{before_tax.to_s('F')}
Tax: $#{tax.to_s('F')}
Total: $#{total.to_s('F')}"
