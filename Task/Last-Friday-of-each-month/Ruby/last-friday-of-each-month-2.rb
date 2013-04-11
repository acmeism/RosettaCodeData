require 'rubygems'
require 'activesupport'

def last_friday(year, month)
  d = Date.new(year, month, 1).end_of_month
  until d.wday == 5
    d = d.yesterday
  end
  d
end
