use bigint;
my $x = 5**4**3**2;
my $y = "$x";
printf("5**4**3**2 = %s...%s and has %i digits\n", substr($y,0,20), substr($y,-20), length($y));
