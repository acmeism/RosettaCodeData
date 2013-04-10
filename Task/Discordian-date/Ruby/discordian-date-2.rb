[[2012, 2, 28], [2012, 2, 29], [2012, 3, 1], [2011, 10, 5]].each do |date|
  dd = DiscordianDate.new(*date)
  puts "#{"%4d-%02d-%02d" % date} => #{dd}"
end
