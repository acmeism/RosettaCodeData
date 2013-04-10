#!/usr/bin/perl
use strict;
use warnings;

use Math::BigInt;

my $nan = Math::BigInt->bnan();
my $pinf = Math::BigInt->binf();
my $ninf = Math::BigInt->binf('-');

print "\$nan = $nan\n";
print "\$pinf = $pinf\n";
print "\$ninf = $ninf\n\n";

my $huge = Math::BigInt->new("123456789");
$huge->bmul($huge)->bmul($huge)->bmul($huge);

print "\$huge = $huge\n";
printf "\$ninf + \$huge = %s\n", $ninf->copy()->badd($huge);
printf "\$pinf - \$huge = %s\n", $pinf->copy()->bsub($huge);
printf "\$nan * \$huge = %s\n", $nan->copy()->bmul($huge);
printf "\$nan == \$nan? %s\n", defined($nan->bcmp($nan)) ? "maybe" : "no";
printf "\$nan == \$huge? %s\n", defined($nan->bcmp($huge)) ? "maybe" : "no";
