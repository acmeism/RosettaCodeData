require 'date'

years = [1578, 1590, 1642, 1957, 2020, 2021, 2022, 2242, 2245, 2393]
years.each do |year|
  xmas = Date.new(year,12,25).strftime("%A")
  ny =   Date.new(year, 1, 1).strftime("%A")
  puts "In #{year}, New year's day is on a #{ny}, and Christmas day on #{xmas}."
end
