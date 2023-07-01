my $S = do { my ($sum, $k); sub { $sum += 1/++$k**2 } };
my @S = map &$S, 1 .. 1000;
print $S[-1];
