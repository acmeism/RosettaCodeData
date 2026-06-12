// 20210315 Perl programming solution

use strict;
use warnings;

my $n = 3;
my @list = 1..9;

push @list, splice @list, 0, $n;

print join ' ', @list, "\n"
