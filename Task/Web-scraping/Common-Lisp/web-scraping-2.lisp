CL-USER> (cl-ppcre:do-matches-as-strings
             (m ".*<BR>(.*)UTC.*"
                (drakma:http-request "http://tycho.usno.navy.mil/cgi-bin/timer.pl"))
           (print (cl-ppcre:regex-replace "<BR>(.*UTC).*" m "\\1")))
"Jul. 13, 06:32:01 UTC"
