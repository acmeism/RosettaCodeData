require 'date'

def easter_date(year)
  # Anonymous Gregorian algorithm
  # http://en.wikipedia.org/wiki/Computus#Algorithms

  a    = year % 19
  b, c = year.divmod(100)
  d, e = b.divmod(4)
  f    = (b + 8) / 25
  g    = (b - f + 1) / 3
  h    = (19*a + b - d - g + 15) % 30
  i, k = c.divmod(4)
  l    = (32 + 2*e + 2*i - h - k) % 7
  m    = (a + 11*h + 22*l) / 451
  numerator = h + l - 7*m + 114
  month = numerator / 31
  day = (numerator % 31) + 1
  Date.new(year, month, day)
end

OFFSETS = [
  [:easter,     0],
  [:ascension, 39],
  [:pentecost, 49],
  [:trinity,   56],
  [:corpus,    60],
]

def emit_dates(year)
  e = easter_date year
  dates = OFFSETS.collect {|item, offset| (e + offset).strftime("  %e %b")}
  puts "%4s: %s" % [year, dates.join(',  ')]
end

puts "year:" + OFFSETS.collect{|item, offset| "%9s" % item}.join(', ')
400.step(2100, 100).each {|year| emit_dates year}
puts
(2010 .. 2020).each {|year| emit_dates year}
