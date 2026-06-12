use v5.36;
use Math::MPFR;
use List::Util 'sum';

sub Gamma ($z) {
    my $g = Math::MPFR->new();
    Math::MPFR::Rmpfr_gamma($g, Math::MPFR->new($z), 0);
    $g;
}

sub chi2($x,$k)      { $x>0 && $k>0 ? ($x**($k/2 - 1) * exp(-$x/2)/(2**($k/2)*Gamma($k / 2))) : 0 }
sub gamma_cdf($k,$x) { $x**$k * exp(-$x) * sum map { $x** $_ / Gamma($k+$_+1) } 0..100 }
sub cdf_chi2($x,$k)  { ($x <= 0 or $k <= 0) ? 0.0 : gamma_cdf($k / 2, $x / 2) }

print 'x           χ² ';
print "k = $_" . ' 'x13 for 1..5;
say "\n" . '-' x (my $width = 93);

for my $x (0..10) {
    printf '%2d', $x;
    printf '  %.' . (int(($width-2)/5)-4) . 'f', chi2($x, $_) for 1..5;
    say '';
}

say "\nχ² x     cdf for χ²   P value (df=3)\n" . '-' x 36;
for my $p (map { 2**$_ } 0..5)  {
    my $cdf = cdf_chi2($p, 3);
    printf "%2d     %-.10f   %-.10f\n", $p, $cdf, 1-$cdf;
}

my @airport  = <77 23 88 12 79 21 81 19>;
my @expected = split ' ', '81.25 18.75 ' x 4;
my $dtotal;
$dtotal += ($airport[$_] - $expected[$_])**2 / $expected[$_] for 0..$#airport;
printf "\nFor the airport data, diff total is %.5f, χ² is %.5f, p value %.5f\n", $dtotal, chi2($dtotal, 3), cdf_chi2($dtotal, 3);
