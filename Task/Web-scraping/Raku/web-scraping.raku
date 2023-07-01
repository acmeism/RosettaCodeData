# 20210301 Updated Raku programming solution

use HTTP::Client; # https://github.com/supernovus/perl6-http-client/

#`[ Site inaccessible since 2019 ?
my $site = "http://tycho.usno.navy.mil/cgi-bin/timer.pl";
HTTP::Client.new.get($site).content.match(/'<BR>'( .+? <ws> UTC )/)[0].say
# ]

my $site = "https://www.utctime.net/";
my $matched = HTTP::Client.new.get($site).content.match(
   /'<td>UTC</td><td>'( .*Z )'</td>'/
)[0];

say $matched;
#$matched = '12321321:412312312 123';
with DateTime.new($matched.Str) {
   say 'The fetch result seems to be of a valid time format.'
} else {
   CATCH { put .^name, ': ', .Str }
}
