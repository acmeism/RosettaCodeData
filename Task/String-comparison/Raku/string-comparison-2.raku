say "\c[KELVIN SIGN]".uniname;
# => LATIN CAPITAL LETTER K

my $kelvin = "\c[KELVIN SIGN]";
my $k = "\c[LATIN CAPITAL LETTER K]";
say ($kelvin eq $k); # True, lexically equal
say ($kelvin eqv $k); # True, generically equal
say ($kelvin === $k); # True, identical objects
