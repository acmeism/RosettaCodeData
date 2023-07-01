my $url = 'http://foo bar/';

say $url.subst(/<-alnum>/, *.ord.fmt("%%%02X"), :g);
