require 'date'

(2008..2121).each {|year| puts "25 Dec #{year}" if Date.new(year, 12, 25).sunday? }
