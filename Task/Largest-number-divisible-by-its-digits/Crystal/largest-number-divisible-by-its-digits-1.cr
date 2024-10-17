magic_number = 9*8*7
div          = (9876432 // magic_number) * magic_number
candidates   = div.step(to: 0, by: -magic_number)

res = candidates.find do |c|
  digits = c.to_s.chars.map(&.to_i)
  (digits & [0,5]).empty? && digits == digits.uniq
end

puts "Largest decimal number is #{res}"
