(2008..2121).each {|year| puts "25 Dec #{year}" if Time.local(year, 12, 25).sunday?}
