set data [exec curl -s http://tycho.usno.navy.mil/cgi-bin/timer.pl]
puts [lrange [lsearch -glob -inline [split $data <BR>] *UTC*] 0 3]
