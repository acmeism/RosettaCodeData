use feature 'say';
use List::Util qw(first);
use Math::Polynomial::Cyclotomic qw(cyclo_poly_iterate);

say 'First 30 cyclotomic polynomials:';
my $it = cyclo_poly_iterate(1);
say "$_: " . $it->() for 1 .. 30;

say "\nSmallest cyclotomic polynomial with n or -n as a coefficient:";
$it = cyclo_poly_iterate(1);

for (my ($n, $k) = (1, 1) ; $n <= 10 ; ++$k) {
    my $poly = $it->();
    while (my $c = first { abs($_) == $n } $poly->coeff) {
        say "CP $k has coefficient with magnitude = $n";
        $n++;
    }
}
