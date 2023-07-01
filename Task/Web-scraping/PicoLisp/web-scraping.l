(load "@lib/http.l")

(client "tycho.usno.navy.mil" 80 "cgi-bin/timer.pl"
   (when (from "<BR>")
      (pack (trim (till "U"))) ) )
