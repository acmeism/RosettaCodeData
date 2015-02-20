def luhn(code)
  s1 = s2 = 0
  code.to_s.reverse.chars.each_slice(2) do |odd, even|
    s1 += odd.to_i

    double = even.to_i * 2
    double -= 9 if double >= 10
    s2 += double
  end
  (s1 + s2) % 10 == 0
end

[49927398716, 49927398717, 1234567812345678, 1234567812345670].each do |n|
  p [n, luhn(n)]
end
