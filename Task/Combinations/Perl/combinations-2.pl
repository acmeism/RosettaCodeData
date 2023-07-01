use Algorithm::Combinatorics qw/combinations/;
my @c = combinations( [0..4], 3 );
print "@$_\n" for @c;
