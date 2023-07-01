my %seen;
my @uniq = grep {!$seen{$_}++} qw(1 2 3 a b c 2 3 4 b c d);
