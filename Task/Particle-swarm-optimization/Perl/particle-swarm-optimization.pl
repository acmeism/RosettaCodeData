use strict;
use warnings;
use feature 'say';

use constant PI  => 2 * atan2(1, 0);
use constant Inf => 1e10;

sub pso_init {
    my(%y) = @_;
    my $d = @{$y{'min'}};
    my $n = $y{'n'};

    $y{'gbval'} = Inf;
    $y{'gbpos'} = [(Inf) x $d];
    $y{'bval'}  = [(Inf) x $n];
    $y{'bpos'}  = [($y{'min'}) x $n];
    $y{'pos'}   = [($y{'min'}) x $n];
    $y{'vel'}   = [([(0) x $d]) x $n];

    %y
}

sub pso {
    my($fn, %y) = @_;
    my $p      = $y{'p'};
    my $n      = $y{'n'};
    my $d      = @{$y{'min'}};
    my @bpos   = ($y{'min'}) x $n;
    my $gbval  = Inf;
    my $rand_g = rand;
    my (@pos, @vel, @v, @gbpos, @bval);

    for my $j (0 .. $n-1) {
        $v[$j] = &$fn(@{$y{'pos'}[$j]}); # evaluate

        # update
        if ($v[$j] < $y{'bval'}[$j]) {
            $bpos[$j] = $y{'pos'}[$j];
            $bval[$j] = $v[$j];
        } else {
            $bpos[$j] = $y{'bpos'}[$j];
            $bval[$j] = $y{'bval'}[$j];
        }
        if ($bval[$j] < $gbval) {
            @gbpos = @{$bpos[$j]};
            $gbval = $bval[$j];
        }
    }

    # migrate
    for my $j (0 .. $n-1) {
        my $rand_p = rand;
        my $ok = 1;
        for my $k (0 .. $d-1) {
            $vel[$j][$k] = $$p{'omega'} * $y{'vel'}[$j][$k]
                       + $$p{'phi_p'} * $rand_p * ($bpos[$j][$k] - $y{'pos'}[$j][$k])
                       + $$p{'phi_g'} * $rand_g * ($gbpos[$k]    - $y{'pos'}[$j][$k]);
            $pos[$j][$k] = $y{'pos'}[$j][$k] + $vel[$j][$k];
            $ok = ($y{'min'}[$k] < $pos[$j][$k]) && ($pos[$j][$k] < $y{'max'}[$k]) && $ok;
        }
        next if $ok;
        $pos[$j][$_] = $y{'min'}[$_] + ($y{'max'}[$_] - $y{'min'}[$_]) * rand for 0 .. $d-1;
    }
    return {gbpos => \@gbpos, gbval => $gbval, bpos => \@bpos, bval => \@bval, pos => \@pos, vel => \@vel,
               min => $y{'min'}, max => $y{'max'}, p=> $y{'p'}, n => $n};
}

sub report {
    my($function_name, %state) = @_;
    say $function_name;
    say 'Global best position: ' . sprintf "%.5f %.5f", @{$state{'gbpos'}};
    say 'Global best value:    ' . sprintf "%.5f",      $state{'gbval'};
    say '';
}

# McCormick
sub mccormick {
    my($a,$b) = @_;
    sin($a+$b) + ($a-$b)**2 + (1 + 2.5*$b - 1.5*$a)
}

my %state = pso_init( (
    min => [-1.5, -3],
    max => [4, 4],
    n   => 100,
    p   => {omega => 0, phi_p => 0.6, phi_g => 0.3},
) );
%state = %{pso(\&mccormick, %state)} for 1 .. 40;
report('McCormick', %state);

# Michalewicz
sub michalewicz {
    my(@x) = @_;
    my $sum;
    my $m = 10;
    for my $i (1..@x) {
        my $j = $x[$i - 1];
        my $k = sin($i * $j**2/PI);
        $sum += sin($j) * $k**(2*$m)
    }
    -$sum
}

%state = pso_init( (
    min => [0, 0],
    max => [PI, PI],
    n   => 1000,
    p   => {omega => 0.3, phi_p => 0.3, phi_g => 0.3},
) );
%state = %{pso(\&michalewicz, %state)} for 1 .. 30;
report('Michalewicz', %state);
