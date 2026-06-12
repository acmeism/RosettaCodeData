use v5.36;
my @A;
my $threshold = 10_000; # redonkulous overkill

for my $x (1..$threshold) {
    X: for my $y (1..$x) {
        last X if $x*$y > $threshold;
        Y: for my $z (1..$y) {
           last Y if (my $area = 2 * ($x*$y + $y*$z + $z*$x)) > $threshold;
           $A[$area] = "$x,$y,$z";
        }
    }

say 'Even integer surface areas NOT achievable by any regular, integer dimensioned cuboid';
for (0..$#A) {
    print "$_ " if $_ < $threshold and $_ > 6 and 0 == $_ % 2 and not $A[$_];
}
