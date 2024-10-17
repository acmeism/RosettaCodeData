def luhn_valid?(card_string)
  digit_sum = card_string.reverse.chars.map.with_index(1) { |c, i|
    digit = c.to_i

    next digit if i.odd?
    next digit if digit == 9

    (digit * 2) % 9
  }.sum

  digit_sum % 10 == 0
end

['49927398716','49927398717','1234567812345678','1234567812345670'].each do |card_string|
  puts "#{card_string}: #{luhn_valid?(card_string)}"
end
