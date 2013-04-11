#! /usr/bin/awk -f

BEGIN {
  purl = "/inet/tcp/0/tycho.usno.navy.mil/80"
  ORS = RS = "\r\n\r\n"
  print "GET /cgi-bin/timer.pl HTTP/1.0" |& purl
  purl |& getline header
  while ( (purl |& getline ) > 0 )
  {
     split($0, a, "\n")
     for(i=1; i <= length(a); i++)
     {
        if ( a[i] ~ /UTC/ )
        {
          sub(/^<BR>/, "", a[i])
          printf "%s\n", a[i]
        }
     }
  }
  close(purl)
}
