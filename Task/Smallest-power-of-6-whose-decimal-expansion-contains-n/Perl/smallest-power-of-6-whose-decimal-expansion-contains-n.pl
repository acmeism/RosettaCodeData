use strict;
use warnings;
use List::Util 'first';
use Math::AnyNum ':overload';

sub comma { reverse ((reverse shift) =~ s/(.{3})/$1,/gr) =~ s/^,//r }

for my $n (0..21, 314159) {
    my $e = first { 6**$_ =~ /$n/ } 0..1000;
    printf "%7d:  6^%-3s  %s\n", $n, $e, comma 6**$e;
}
