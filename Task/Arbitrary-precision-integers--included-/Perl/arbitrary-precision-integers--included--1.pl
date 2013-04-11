use Math::BigInt;
my $x = Math::BigInt->new('5') ** Math::BigInt->new('4') ** Math::BigInt->new('3') ** Math::BigInt->new('2');
my $y = "$x";
printf("5**4**3**2 = %s...%s and has %i digits\n", substr($y,0,20), substr($y,-20), length($y));
