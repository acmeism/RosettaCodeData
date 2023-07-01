def happy?(n)
  past = [] of Int32 | Int64
  until n == 1
    sum = 0; while n > 0; sum += (n % 10) ** 2; n //= 10 end
    return false if past.includes? (n = sum)
    past << n
  end
  true
end

i = count = 0
until count == 8; (puts i; count += 1) if happy?(i += 1) end
puts
(99999999999900..99999999999999).each { |i| puts i if happy?(i) }
