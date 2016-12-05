#!/bin/sh
curl -s http://tycho.usno.navy.mil/cgi-bin/timer.pl |
   sed -ne 's/^<BR>\(.* UTC\).*$/\1/p'
