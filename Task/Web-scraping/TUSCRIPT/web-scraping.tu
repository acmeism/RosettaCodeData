$$ MODE TUSCRIPT
SET time = REQUEST ("http://tycho.usno.navy.mil/cgi-bin/timer.pl")
SET utc  = FILTER  (time,":*UTC*:",-)
