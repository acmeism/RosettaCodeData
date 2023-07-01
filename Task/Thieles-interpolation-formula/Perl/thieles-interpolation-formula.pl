use strict;
use warnings;
use feature 'say';
use Math::Trig;
use utf8;

sub thiele {
    my($x, $y) = @_;

    my @ρ;
    push @ρ, [($$y[$_]) x (@$y-$_)] for 0 .. @$y-1;
    for my $i (0 .. @ρ - 2) {
        $ρ[$i][1] = (($$x[$i] - $$x[$i+1]) / ($ρ[$i][0] - $ρ[$i+1][0]))
    }
    for my $i (2 .. @ρ - 2) {
        for my $j (0 .. (@ρ - 2) - $i) {
            $ρ[$j][$i] = ((($$x[$j]-$$x[$j+$i]) / ($ρ[$j][$i-1]-$ρ[$j+1][$i-1])) + $ρ[$j+1][$i-2])
        }
    }
    my @ρ0 = @{$ρ[0]};

    return sub {
        my($xin) = @_;

        my $a = 0;
        for my $i (reverse 2 .. @ρ0 - 2) {
            $a = (($xin - $$x[$i-1]) / ($ρ0[$i] - $ρ0[$i-2] + $a))
        }
        $$y[0] + (($xin - $$x[0]) / ($ρ0[1] + $a))
    }
}

my(@x,@sin_table,@cos_table,@tan_table);
push @x,  .05 * $_ for 0..31;
push @sin_table, sin($_) for @x;
push @cos_table, cos($_) for @x;
push @tan_table, tan($_) for @x;

my $sin_inverse = thiele(\@sin_table, \@x);
my $cos_inverse = thiele(\@cos_table, \@x);
my $tan_inverse = thiele(\@tan_table, \@x);

say 6 * &$sin_inverse(0.5);
say 3 * &$cos_inverse(0.5);
say 4 * &$tan_inverse(1.0);
