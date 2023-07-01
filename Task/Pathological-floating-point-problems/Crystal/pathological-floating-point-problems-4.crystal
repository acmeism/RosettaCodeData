require "big"

e = 106246577894593683.to_big_d.div(39085931702241241.to_big_d)

balance = e - 1
1.upto(25) { |y| balance = (balance * y) - 1 }
puts "Bank balance after 25 years = #{balance.to_f}"
