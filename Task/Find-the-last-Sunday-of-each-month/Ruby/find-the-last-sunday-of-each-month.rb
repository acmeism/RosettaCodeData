require 'date'

def last_sundays_of_year(year = Date.today.year)
  (1..12).map do |month|
    d = Date.new(year, month, -1) # -1 means "last".
    d - d.wday
  end
end

puts last_sundays_of_year(2013)
