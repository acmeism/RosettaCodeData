def long_year? (year)
  Time.utc(year, 12, 28).calendar_week.last == 53
end

puts "Long years between 1800 and 2100:"
puts (1800..2100).select {|year| long_year? year }
