require 'prime'

puts File.open("unixdict.txt").select{|line| line.chomp.chars.all?{|c| c.ord.prime?} }
