#!/bin/bash
  curl -Ss 'http://tycho.usno.navy.mil/cgi-bin/timer.pl' |\
    jq -R -r 'if index(" UTC") then .[4:] else empty end'
