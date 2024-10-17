time = Time.parse("March 7 2009 7:30pm EST", "%B %-d %Y %l:%M%p", Time::Location.load("EST"))

time += 12.hours
puts time                                          # 2009-03-08 07:30:00 -05:00
puts time.in(Time::Location.load("Europe/Berlin")) # 2009-03-08 13:30:00 +01:00
