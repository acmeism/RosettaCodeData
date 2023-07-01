require 'date'

def last_friday(year, month)
  # Last day of month: Date.new interprets a negative number as a relative month/day from the end of year/month.
  d = Date.new(year, month, -1)
  d -= (d.wday - 5) % 7  # Subtract days after Friday.
end

year = Integer(ARGV.shift)
(1..12).each {|month| puts last_friday(year, month)}
