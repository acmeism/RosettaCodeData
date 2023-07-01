use strict;
use warnings;

use Primesieve;

sub comma { reverse ((reverse shift) =~ s/(.{3})/$1,/gr) =~ s/^,//r }

printf "Twin prime pairs less than %14s: %s\n", comma(10**$_), comma count_twins(1, 10**$_) for 1..10;
