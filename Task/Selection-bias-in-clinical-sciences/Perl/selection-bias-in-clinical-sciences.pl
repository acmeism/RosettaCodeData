use v5.036;
use List::AllUtils <sum0 indexes firstidx>;
use enum qw<False True UNTREATED REGULAR IRREGULAR>;
use constant DOSE_FOR_REGULAR => 100;

my ($nSubjects,$duration,$interval) = (10000, 180, 30);
my (@dosage)   = (0)         x $nSubjects;
my (@category) = (UNTREATED) x $nSubjects;
my (@hadcovid) = (False)     x $nSubjects;

sub update {
    my $pCovid          = 1e-3;
    my $pStartTreatment = 5e-3;
    my $pRedose         = 1/4;
    my @dRange          = <3 6 9>;
    for my $i (0 .. $nSubjects-1) {
        unless ($hadcovid[$i]) {
            if (rand() < $pCovid) {
                $hadcovid[$i] = True
            } else {
                my $dose = $dosage[$i];
                if ($dose==0 && rand() < $pStartTreatment or $dose > 0 && rand() < $pRedose) {
                    $dosage[$i]   = $dose += $dRange[3*rand()];
                    $category[$i] = ($dose > DOSE_FOR_REGULAR) ? REGULAR : IRREGULAR
                }
            }
        }
    }
}

sub kruskal (@sets) {
     my @ranked     = sort @{$sets[0]}, @{$sets[1]}, @{$sets[2]};
     my $n          = @ranked;
     my @sr         = (0) x @sets;
     my $ix         = firstidx { $_ == 1 } @ranked;
     my ($arf,$art) = ($ix/2, ($ix+$n)/2);

    for my $i (0..2) {
        $sr[$i] += $_ ? $art : $arf for @{$sets[$i]}
    }

    my $H = sum0 map { my $s = $sr[$_]; $s**2 / @{$sets[$_]} } 0..$#sr;
    12/($n*($n+1)) * $H - 3 * ($n + 1)
}

my($unt,$irr,$reg,$hunt,$hirr,$hreg,@sunt,@sirr,@sreg);
my $midpoint = int $duration / 2;

say "Total subjects: $nSubjects\n";

for my $day (1 .. $duration) {
    update();
    if (0 == $day % $interval or $day == $duration or $day == $midpoint) {
        @sunt = @hadcovid[ indexes { $_ == UNTREATED } @category];
        @sirr = @hadcovid[ indexes { $_ == IRREGULAR } @category];
        @sreg = @hadcovid[ indexes { $_ ==   REGULAR } @category];
        ( $unt, $irr, $reg) = (scalar(@sunt), scalar(@sirr), scalar(@sreg));
        ($hunt,$hirr,$hreg) = (  sum0(@sunt),   sum0(@sirr),   sum0(@sreg));
    }

    if (0 == $day % $interval) {
        printf "Day %d:\n", $day;
        printf "Untreated:     N = %4d, with infection = %4d\n",  $unt,$hunt;
        printf "Irregular Use: N = %4d, with infection = %4d\n",  $irr,$hirr;
        printf "Regular Use:   N = %4d, with infection = %4d\n\n",$reg,$hreg;
    }

    if ($day == $midpoint or $day == $duration) {
        my $stage = $day == $midpoint ? 'midpoint' : 'study end';
        printf "At $stage, Infection case percentages are:\n";
        printf "  Untreated : %6.2f\n",   100*$hunt/$unt;
        printf "  Irregulars: %6.2f\n",   100*$hirr/$irr;
        printf "  Regulars  : %6.2f\n\n", 100*$hreg/$reg;
    }
}

printf "Final statistics: H = %.2f\n", kruskal ( \@sunt, \@sirr, \@sreg );

