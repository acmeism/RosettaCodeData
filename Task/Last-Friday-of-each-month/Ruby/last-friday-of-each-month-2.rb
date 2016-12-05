require 'date'

def last_friday(year, month)
  d = Date.new(year, month, -1)
  d = d.prev_day until d.friday?
  d
end
