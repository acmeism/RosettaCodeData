#!/usr/bin/tcsh -f
set page = `wget -q -O- "http://tycho.usno.navy.mil/cgi-bin/timer.pl"`
echo `awk -v s="${page[22]}" 'BEGIN{print substr(s,5,length(s))}'` ${page[23]} ${page[24]}
