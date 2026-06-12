use strict;
use warnings;
use feature <say state>;

sub ulam {
    my($n) = @_;
    state %u     = (1 => 1, 2 => 1);
    state @ulams = <0 1 2>; # 0 a placeholder to shift indexing up one

    return $ulams[$n] if $ulams[$n];

    $n++;
    my $i = 3;

    while () {
        my $count = 0;

            $u{ $i - $ulams[$_] }
        and $ulams[$_] != $i - $ulams[$_]
        and $count++ > 2
        and last
            for 0..$#ulams;

            $count == 2
        and push(@ulams,$i)
        and $u{$i} = 1
        and @ulams == $n
        and last;

        $i++;
    }
    $ulams[$n-1];
}

printf "The %dth Ulam number is: %d\n", 10**$_, ulam(10**$_) for 1..4;
