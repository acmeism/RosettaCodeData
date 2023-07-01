#!/usr/bin/perl
use strict;
use warnings;

my $nzero = -0.0;
my $nan = 0 + "nan";
my $pinf = +"inf";
my $ninf = -"inf";

printf "\$nzero = %.1f\n", $nzero;
print "\$nan = $nan\n";
print "\$pinf = $pinf\n";
print "\$ninf = $ninf\n\n";

printf "atan2(0, 0) = %g\n", atan2(0, 0);
printf "atan2(0, \$nzero) = %g\n", atan2(0, $nzero);
printf "sin(\$pinf) = %g\n", sin($pinf);
printf "\$pinf / -1 = %g\n", $pinf / -1;
printf "\$ninf + 1e100 = %g\n\n", $ninf + 1e100;

printf "nan test: %g\n", (1 + 2 * 3 - 4) / (-5.6e7 * $nan);
printf "nan == nan? %s\n", ($nan == $nan) ? "yes" : "no";
printf "nan == 42? %s\n", ($nan == 42) ? "yes" : "no";
