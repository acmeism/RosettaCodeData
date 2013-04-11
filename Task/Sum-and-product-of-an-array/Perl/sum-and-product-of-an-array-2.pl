use List::Util qw( sum reduce );
my @list = ( 1, 2, 3 );

my $sum1    = sum 0, @list;                    # 0 identity to allow empty list
my $sum2    = reduce { $a + $b } 0, @list;
my $product = reduce { $a * $b } 1, @list;
