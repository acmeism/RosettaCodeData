my $str = 'abcdefgh';
my $n = 2;
my $m = 3;
say $str.substr($n, $m);
say $str.substr($n);
say $str.substr(0, *-1);
say $str.substr($str.index('d'), $m);
say $str.substr($str.index('de'), $m);
