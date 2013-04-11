my %seen;
@seen{qw(1 2 3 a b c 2 3 4 b c d)} = ();
my @uniq = keys %seen;
