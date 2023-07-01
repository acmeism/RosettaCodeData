def divByAll(num, digits)
  digits.all? { |digit| num % digit.to_i(16) == 0 }
end

magic = 15 * 14 * 13 * 12 * 11
high = (0xfedcba987654321 / magic) * magic

high.step(magic, -magic) do |i|
  s = i.to_s(16)               # always generates lower case a-f
  next if s.include? "0"       # can't contain '0'
  sd = s.chars.uniq
  next if sd.size != s.size    # digits must be unique
  (puts "Largest hex number is #{i.to_s(16)}"; break) if divByAll(i, sd)
end
