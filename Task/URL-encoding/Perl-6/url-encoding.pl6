my $url = 'http://foo bar/';

say $url.subst(/<-[ A..Z a..z 0..9 ]>/, *.ord.fmt("%%%02X"), :g);
