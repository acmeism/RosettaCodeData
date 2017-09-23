def luhn(code)
  csum = 0
  code.digits.each_slice(2) do |odd, even|
    double = even.to_i * 2
    double -= 9 if double > 9
    csum += double + odd
  end
  csum % 10 == 0
end

[49927398716, 49927398717, 1234567812345678, 1234567812345670].each do |n|
  p [n, luhn(n)]
end
