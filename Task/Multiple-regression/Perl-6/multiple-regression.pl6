use Clifford;
my @height = <1.47 1.50 1.52 1.55 1.57 1.60 1.63 1.65 1.68 1.70 1.73 1.75 1.78 1.80 1.83>;
my @weight = <52.21 53.12 54.48 55.84 57.20 58.57 59.93 61.29 63.11 64.47 66.28 68.10 69.92 72.19 74.46>;

my $w = [+] @weight Z* @e;

my $h0 = [+] @e[^@weight];
my $h1 = [+] @height Z* @e;
my $h2 = [+] (@height X** 2) Z* @e;

my $I = $h0∧$h1∧$h2;
my $I2 = ($I·$I.reversion).Real;

say "α = ", ($w∧$h1∧$h2)·$I.reversion/$I2;
say "β = ", ($w∧$h2∧$h0)·$I.reversion/$I2;
say "γ = ", ($w∧$h0∧$h1)·$I.reversion/$I2;
