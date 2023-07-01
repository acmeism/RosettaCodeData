sub encode($str) { $str.subst(/(.) $0*/, { $/.chars ~ $0 }, :g) }

sub decode($str) { $str.subst(/(\d+) (.)/, { $1 x $0 }, :g) }

my $e = encode('WWWWWWWWWWWWBWWWWWWWWWWWWBBBWWWWWWWWWWWWWWWWWWWWWWWWBWWWWWWWWWWWWWW');
say $e;
say decode($e);
