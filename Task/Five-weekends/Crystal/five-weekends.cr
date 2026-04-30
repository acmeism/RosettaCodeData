years = (1900..2100).to_a
long_months = [1, 3, 5, 7, 8, 10, 12]
five_wknd_months = years.cartesian_product(long_months).select {|year, month|
  Time.utc(year, month, 1).friday?
}
puts "#{five_wknd_months.size} months with 5 weekends:"
puts five_wknd_months.first(10).map {|y, m| "#{m}/#{y}" }.join(" ")
puts "   ..."
puts five_wknd_months.last(10).map {|y, m| "#{m}/#{y}" }.join(" ")
puts
years_without = years - five_wknd_months.map {|year, _| year }
puts "#{years_without.size} years without 5-weekend-months:"
puts years_without.join(" ")
