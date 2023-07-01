def divByAll(num, digits)
  digits.all? { |digit| num % digit.to_i(16) == 0 }
end

magic = 15_i64 * 14 * 13 * 12 * 11
high = (0xfedcba987654321_i64 // magic) * magic

high.step(to: magic, by: -magic) do |i|
  s = i.to_s(16)               # always generates lower case a-f
  next if s.includes?('0') || s.chars.uniq.size != s.size # need uniq non-zero digits
  (puts "Largest hex number is #{i.to_s(16)}"; break) if divByAll(i, s.chars)
end
