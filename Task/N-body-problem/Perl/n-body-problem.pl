use strict;
use warnings;

use constant PI         => 3.141592653589793;
use constant SOLAR_MASS => (4 * PI * PI);
use constant YEAR       => 365.24;

sub solar_offset {
    my($vxs, $vys, $vzs, $mass) = @_;
    my($px, $py, $pz);
    for (0..@$mass-1) {
        $px += @$vxs[$_] * @$mass[$_];
        $py += @$vys[$_] * @$mass[$_];
        $pz += @$vzs[$_] * @$mass[$_];
    }
    (@$vxs[0], @$vys[0], @$vzs[0]) = ((-$px/SOLAR_MASS), (-$py/SOLAR_MASS), (-$pz/SOLAR_MASS));
}

sub orbit {
    my ($dt, $xs, $ys, $zs, $vxs, $vys, $vzs, $mass) = @_;
    for (0..@$mass-1) {
        for (my $j = $_ + 1; $j < @$mass; $j++) {
            my($dx, $dy, $dz) = ((@$xs[$_] - @$xs[$j]), (@$ys[$_] - @$ys[$j]), (@$zs[$_] - @$zs[$j]));
            my $mag = $dt / ($dx**2 + $dy**2 + $dz**2)**(3/2);
            my($mm, $mm2) = ((@$mass[$_] * $mag), (@$mass[$j] * $mag));
            @$vxs[$_] -= $dx * $mm2;
            @$vxs[$j] += $dx * $mm;
            @$vys[$_] -= $dy * $mm2;
            @$vys[$j] += $dy * $mm;
            @$vzs[$_] -= $dz * $mm2;
            @$vzs[$j] += $dz * $mm;
        }
        @$xs[$_] += $dt * @$vxs[$_];
        @$ys[$_] += $dt * @$vys[$_];
        @$zs[$_] += $dt * @$vzs[$_];
    }
}

sub display {
    my($t,$xs,$ys) = @_;
    printf '%6d', $t;
    printf '%7.2f' x 2, @$xs[$_],@$ys[$_] for 1..4;
    print "\n";
}

my @ns =                         <Sun   Jupiter          Saturn           Uranus           Neptune       >;
my @xs =                         <0     4.84143144e+00   8.34336671e+00   1.28943695e+01   1.53796971e+01>;
my @ys =                         <0    -1.16032004e+00   4.12479856e+00  -1.51111514e+01  -2.59193146e+01>;
my @zs =                         <0    -1.03622044e-01  -4.03523417e-01  -2.23307578e-01   1.79258772e-01>;
my @vxs = map {$_ * YEAR}        <0     1.66007664e-03  -2.76742510e-03   2.96460137e-03   2.68067772e-03>;
my @vys = map {$_ * YEAR}        <0     7.69901118e-03   4.99852801e-03   2.37847173e-03   1.62824170e-03>;
my @vzs = map {$_ * YEAR}        <0    -6.90460016e-05   2.30417297e-05  -2.96589568e-05  -9.51592254e-05>;
my @mass = map {$_ * SOLAR_MASS} <1     9.54791938e-04   2.85885980e-04   4.36624404e-05   5.15138902e-05>;
solar_offset(\@vxs, \@vys, \@vzs, \@mass);

printf '     t' . '%14s'x4 . "\n", @ns[1..4];
display(0, \@xs, \@ys);
my $steps = 16567;
for my $t (1 .. $steps) {
    orbit(0.01, \@xs, \@ys, \@zs, \@vxs, \@vys, \@vzs, \@mass);
    display($t,\@xs, \@ys) unless $t % 1000;
}
display($steps, \@xs, \@ys);
