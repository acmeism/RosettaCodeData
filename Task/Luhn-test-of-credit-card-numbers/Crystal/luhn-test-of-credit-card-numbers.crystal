def luhn_valid?(n)  # Card values can be numbers or strings
  d2sum = [0, 2, 4, 6, 8, 1, 3, 5, 7, 9]
  sum, n = 0, n.to_u64
  while n > 0; sum += n%10; n //= 10; sum += d2sum[n%10]; n //= 10 end
  sum % 10 == 0
end

cards = [49927398716, "49927398717", 1234567812345678, "1234567812345670"]
cards.each{ |i| puts "#{i}: #{luhn_valid?(i)}" }
