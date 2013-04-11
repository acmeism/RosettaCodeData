[2000, 1900, 1800, 1700, 1600, 1500, 1400].each do |year|
  print year, (leap_year? year) ? " is" : " is not", " a leap year.\n"
end
