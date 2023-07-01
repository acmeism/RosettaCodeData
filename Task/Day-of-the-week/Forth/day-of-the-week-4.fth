include lib/time.4th

: yuletide
  ." December 25 is Sunday in "
  2122 2008 do
    25 12 i weekday
    6 = if i . then
  loop cr ;

cr yuletide
