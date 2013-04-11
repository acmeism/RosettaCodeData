my @keys = qw(a b c);
my @vals = (1, 2, 3);
my %hash;
@hash{@keys} = @vals;
