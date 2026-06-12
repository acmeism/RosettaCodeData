use utf8;
use strict;
use warnings;
use List::Util qw(shuffle sum);

# simulation setup
my $cities = 100;  # number of cities
my $kmax   = 1e6;  # iterations to run
my $kT     = 1;    # initial 'temperature'

die 'City count must be a perfect square.' if sqrt($cities) != int sqrt($cities);

# locations of (up to) 8 neighbors, with grid size derived from number of cities
my $gs = sqrt $cities;
my @neighbors = (1, -1, $gs, -$gs, $gs-1, $gs+1, -($gs+1), -($gs-1));

# matrix of distances between cities
my @D;
for my $j (0 .. $cities**2 - 1) {
    my ($ab, $cd)       = (int($j/$cities), int($j%$cities));
    my ($a, $b, $c, $d) = (int($ab/$gs), int($ab%$gs), int($cd/$gs), int($cd%$gs));
    $D[$ab][$cd] = sqrt(($a - $c)**2 + ($b - $d)**2);
}

# temperature function, decreases to 0
sub T {
    my($k, $kmax, $kT) = @_;
    (1 - $k/$kmax) * $kT
}

# probability to move from s to s_next
sub P {
    my($ΔE, $k, $kmax, $kT) = @_;
    exp -$ΔE / T($k, $kmax, $kT)
}

# energy at s, to be minimized
sub Es {
    my(@path) = @_;
    sum map { $D[ $path[$_] ] [ $path[$_+1] ] } 0 .. @path-2
}

# variation of E, from state s to state s_next
sub delta_E {
    my($u, $v, @s) = @_;
    my ($a,   $b,  $c,  $d) = ($D[$s[$u-1]][$s[$u]], $D[$s[$u+1]][$s[$u]], $D[$s[$v-1]][$s[$v]], $D[$s[$v+1]][$s[$v]]);
    my ($na, $nb, $nc, $nd) = ($D[$s[$u-1]][$s[$v]], $D[$s[$u+1]][$s[$v]], $D[$s[$v-1]][$s[$u]], $D[$s[$v+1]][$s[$u]]);
    if    ($v == $u+1) { return ($na + $nd) - ($a + $d) }
    elsif ($u == $v+1) { return ($nc + $nb) - ($c + $b) }
    else               { return ($na + $nb + $nc + $nd) - ($a + $b + $c + $d) }
}

# E(s0), initial state
my @s = 0; map { push @s, $_ } shuffle 1..$cities-1; push @s, 0;
my $E_min_global = my $E_min = Es(@s);

for my $k (0 .. $kmax-1) {
    printf "k:%8u  T:%4.1f  Es: %3.1f\n" , $k, T($k, $kmax, $kT), Es(@s)
            if $k % ($kmax/10) == 0;

    # valid candidate cities (exist, adjacent)
    my $u = 1 + int rand $cities-1;
    my $cv = $neighbors[int rand 8] + $s[$u];
    next if $cv <= 0 or $cv >= $cities or $D[$s[$u]][$cv] > sqrt(2);

    my $v  = $s[$cv];
    my $ΔE = delta_E($u, $v, @s);
    if ($ΔE < 0 or P($ΔE, $k, $kmax, $kT) >= rand) { # always move if negative
        ($s[$u], $s[$v]) = ($s[$v], $s[$u]);
        $E_min += $ΔE;
        $E_min_global = $E_min if $E_min < $E_min_global;
    }
}

printf "\nE(s_final): %.1f\n", $E_min_global;
for my $l (0..4) {
   printf "@{['%4d' x 20]}\n", @s[$l*20 .. ($l+1)*20 - 1];
}
printf "   0\n";
