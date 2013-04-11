use HTTP::Client; # http://github.com/carlins/http-client/
my $site = "http://tycho.usno.navy.mil/cgi-bin/timer.pl";
HTTP::Client.new.get($site).match(/'<BR>'( .+? <ws> UTC )/)[0].say
