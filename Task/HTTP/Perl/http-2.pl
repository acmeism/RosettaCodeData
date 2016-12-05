use LWP::Simple qw/get $ua/;
$ua->agent(undef) ; # cloudflare blocks default LWP agent
print( get("http://www.rosettacode.org") );
