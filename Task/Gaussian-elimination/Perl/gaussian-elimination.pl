use Math::Matrix;
my $a = Math::Matrix->new([0,1,0],
                          [0,0,1],
                          [2,0,1]);
my $b = Math::Matrix->new([1],
                          [2],
                          [4]);
my $x = $a->concat($b)->solve;
print $x;
