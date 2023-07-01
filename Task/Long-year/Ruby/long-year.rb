require 'date'

def long_year?(year = Date.today.year)
  Date.new(year, 12, 28).cweek == 53
end

(2020..2030).each{|year| puts "#{year} is long? #{ long_year?(year) }." }
