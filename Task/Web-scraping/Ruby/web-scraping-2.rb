require 'open-uri'
puts URI.parse('http://tycho.usno.navy.mil/cgi-bin/timer.pl').read.match(/ (\d{1,2}:\d{1,2}:\d{1,2}) UTC/)[1]
