def happy?(n)
  past = []			
  until n == 1
    n = n.digits.sum { |d| d * d }
    return false if past.include? n
    past << n
  end
  true
end

i = count = 0
until count == 8; puts i or count += 1 if happy?(i += 1) end
puts
(99999999999900..99999999999999).each { |i| puts i if happy?(i) }
