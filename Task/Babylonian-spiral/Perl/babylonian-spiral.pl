use strict;
use warnings;
use feature <say state>;
use constant TAU => 2 * 2 * atan2(1, 0);

sub B_spiral {
    my($nsteps) = @_;
    my @squares = map $_**2, 0..$nsteps+1;
    my @dxys = ([0, 0], [0, 1]);
    my $dsq  = 1;

    for (1 .. $nsteps-2) {
        my ($x,$y) = @{$dxys[-1]};
        our $theta = atan2 $y, $x;
        my @candidates;

        until (@candidates) {
            $dsq++;
            for my $i (0..$#squares) {
                my $a = $squares[$i];
                next if $a > $dsq/2;
                for my $j ( reverse 0 .. 1 + int sqrt $dsq ) {
                    my $b = $squares[$j];
                    next if ($a + $b) < $dsq;
                    if ($dsq == $a + $b) {
                        push @candidates, ( [$i, $j], [-$i, $j], [$i, -$j], [-$i, -$j],
                                            [$j, $i], [-$j, $i], [$j, -$i], [-$j, -$i] );
                    }
                }
            }
        }

        sub comparer {
            my $i = ($theta - atan2 $_[1], $_[0]);
            my $z = $i - int($i / TAU) * TAU;
            $z < 0 ? TAU + $z : $z;
        }

        push @dxys, (sort { comparer(@$b) < comparer(@$a) } @candidates)[0];
    }

    map { state($x,$y); $x += $$_[0]; $y += $$_[1]; [$x,$y] } @dxys;
}

my @points = map { sprintf "(%3d,%4d)", @$_ } B_spiral(40);
say "The first 40 Babylonian spiral points are:\n" .
    join(' ', @points) =~ s/.{1,88}\K/\n/gr;
