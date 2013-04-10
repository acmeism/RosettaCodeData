SUNDAY = 0

(2008..2121).each do |year|
  begin
    day = Time.local(year, 12, 25)
    puts "25 Dec #{year}" if day.wday == SUNDAY # Ruby 1.9: if day.sunday?
  rescue ArgumentError
    puts '%d is the last year we can specify' % (year-1)
    break
  end
end
