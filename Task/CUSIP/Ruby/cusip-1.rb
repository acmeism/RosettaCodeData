#!/usr/bin/env ruby

def check_cusip(cusip)
  abort('CUSIP must be 9 characters') if cusip.size != 9

  sum = 0
  cusip.split('').each_with_index do |char, i|
    next if i == cusip.size - 1
    case
    when char.scan(/\D/).empty?
      v = char.to_i
    when char.scan(/\D/).any?
      pos = char.upcase.ord - 'A'.ord + 1
      v = pos + 9
    when char == '*'
      v = 36
    when char == '@'
      v = 37
    when char == '#'
      v = 38
    end

    v *= 2 unless (i % 2).zero?
    sum += (v/10).to_i + (v % 10)
  end

  check = (10 - (sum % 10)) % 10
  return 'VALID' if check.to_s == cusip.split('').last
  'INVALID'
end

CUSIPs = %w[
  037833100 17275R102 38259P508 594918104 68389X106 68389X105
]

CUSIPs.each do |cusip|
  puts "#{cusip}: #{check_cusip(cusip)}"
end
