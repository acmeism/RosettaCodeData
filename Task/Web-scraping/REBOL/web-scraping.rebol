REBOL [
  Title: "Web Scraping"
  Author: oofoe
  Date: 2009-12-07
  URL: http://rosettacode.org/wiki/Web_Scraping
]

; Notice that REBOL understands unquoted URL's:

service: http://tycho.usno.navy.mil/cgi-bin/timer.pl

; The 'read' function can read from any data scheme that REBOL knows
; about, which includes web URLs. NOTE: Depending on your security
; settings, REBOL may ask you for permission to contact the service.

html: read service

; I parse the HTML to find the first <br> (note the unquoted HTML tag
; -- REBOL understands those too), then copy the current time from
; there to the "UTC" terminator.

; I have the "to end" in the parse rule so the parse will succeed.
; Not strictly necessary once I've got the time, but good practice.

parse html [thru <br> copy current thru "UTC" to end]

print ["Current UTC time:" current]
