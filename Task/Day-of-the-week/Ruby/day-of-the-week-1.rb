require 'date'

(2008..2121).each do |year|
  puts "25 Dec #{year}" if Date.new(year, 12, 25).wday == 0 # Ruby 1.9: if Date.new(year, 12, 25).sunday?
end
