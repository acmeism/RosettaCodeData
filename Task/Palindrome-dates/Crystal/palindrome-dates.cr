count = 0
(2020..).each do |year|
  digits = year.digits
  month = digits[0]*10 + digits[1]
  next unless 1 <= month <= 12
  day = digits[2]*10 + digits[3]
  next unless 1 <= day <= Time.days_in_month(year, month)
  puts "%4d-%02d-%02d" % {year, month, day}
  break if (count += 1) == 15
end
