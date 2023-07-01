use Lingua::EN::Numbers;

my @H = [\+] (1..*).map: { FatRat.new: 1, $_ };

say "First twenty harmonic numbers as rationals:\n",
    @H[^20]».&pretty-rat.batch(5)».fmt("%18s").join: "\n";

put "\nOne Hundredth:\n", pretty-rat @H[99];

say "\n(zero based) Index of first value:";
printf "  greater than %2d: %6s (%s term)\n",
  $_, comma( my $i = @H.first(* > $_, :k) ), ordinal 1 + $i for 1..10;
