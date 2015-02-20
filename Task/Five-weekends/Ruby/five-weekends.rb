require 'date'
# The only case where the month has 5 weekends is when the last day
# of the month falls on a Sunday and the month has 31 days.

dates = []
1900.upto(2100) do |year|
  1.upto(12) do |month|
    d = Date.new(year, month, -1) # -1 is last day of month
    dates << d if d.sunday? && d.day == 31
  end
end

puts "There are #{dates.size} months with 5 weekends from 1900 to 2100:"
puts dates.first(5).map { |d| d.strftime("%b %Y") }
puts "..."
puts dates.last(5).map { |d| d.strftime("%b %Y") }

years_with_5w = dates.map(&:year)

years = (1900..2100).to_a - years_with_5w

puts "There are #{years.size} years without months with 5 weekends:"
puts years.join(", ")
