require "open-uri"

open('http://tycho.usno.navy.mil/cgi-bin/timer.pl') do |p|
  p.each_line do |line|
    if line =~ /UTC/
      puts line.match(/ (\d{1,2}:\d{1,2}:\d{1,2}) /)
      break
    end
  end
end
