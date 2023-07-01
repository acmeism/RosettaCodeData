magic_number = 9*8*7
div          = 9876432.div(magic_number) * magic_number
candidates   = div.step(0, -magic_number)

res = candidates.find do |c|
  digits = c.digits
  (digits & [0,5]).empty? && digits == digits.uniq
end

puts "Largest decimal number is #{res}"
