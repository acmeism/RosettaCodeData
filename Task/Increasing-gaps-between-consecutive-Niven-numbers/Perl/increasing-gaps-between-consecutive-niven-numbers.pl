use strict;
use warnings;
use List::Util 'sum';

sub comma { reverse ((reverse shift) =~ s/(.{3})/$1,/gr) =~ s/^,//r }

my ($index, $last, $gap, $count) = (0, 0, 0, 0);
my $threshold = 10_000_000;

print "Gap    Index of gap  Starting Niven\n";
while (1) {
    $count++;
    next unless 0 == $count % sum split //, $count;
    if ((my $diff = $count - $last) > $gap) {
        $gap = $diff;
        printf "%3d %15s %15s\n", $gap, $index > 1 ? comma $index : 1, $last > 1 ? comma $last : 1;
    }
    $last = $count;
    last if ++$index >= $threshold;
}
