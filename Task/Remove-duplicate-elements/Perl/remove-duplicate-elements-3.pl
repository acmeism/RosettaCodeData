my %hash = map { $_ => 1 } qw(1 2 3 a b c 2 3 4 b c d);
my @uniq = keys %hash;
