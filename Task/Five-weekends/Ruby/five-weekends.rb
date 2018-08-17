require 'date'
# The only case where the month has 5 weekends is when the last day
# of the month falls on a Sunday and the month has 31 days.

LONG_MONTHS = [1,3,5,7,8,10,12]
YEARS       = (1900..2100).to_a

dates    = YEARS.product(LONG_MONTHS).map{|y, m| Date.new(y,m,31)}.select(&:sunday?)
years_4w = YEARS - dates.map(&:year)

puts "There are #{dates.size} months with 5 weekends from 1900 to 2100:"
puts dates.first(5).map {|d| d.strftime("%b %Y") }, "..."
puts dates.last(5).map {|d| d.strftime("%b %Y") }
puts "There are #{years_4w.size} years without months with 5 weekends:"
puts years_4w.join(", ")
