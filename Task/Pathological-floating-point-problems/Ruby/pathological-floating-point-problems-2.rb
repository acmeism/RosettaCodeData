require 'bigdecimal/math'
balance = BigMath.E(50) - 1
1.upto(25){|y| balance = balance * y - 1}
puts "Bank balance after 25 years = #{balance.to_f}"
