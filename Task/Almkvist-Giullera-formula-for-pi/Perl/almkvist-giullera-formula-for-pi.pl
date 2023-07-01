use strict;
use warnings;
use feature qw(say);
use Math::AnyNum qw(:overload factorial);

sub almkvist_giullera_integral {
    my($n) = @_;
    (32 * (14*$n * (38*$n + 9) + 9) * factorial(6*$n)) / (3*factorial($n)**6);
}

sub almkvist_giullera {
    my($n) = @_;
    almkvist_giullera_integral($n) / (10**(6*$n + 3));
}

sub almkvist_giullera_pi {
    my ($prec) = @_;

    local $Math::AnyNum::PREC = 4*($prec+1);

    my $sum = 0;
    my $target = '';

    for (my $n = 0; ; ++$n) {
        $sum += almkvist_giullera($n);
        my $curr = ($sum**-.5)->as_dec;
        return $target if ($curr eq $target);
        $target = $curr;
    }
}

say 'First 10 integer portions: ';
say "$_  " . almkvist_giullera_integral($_) for 0..9;

my $precision = 70;

printf("π to %s decimal places is:\n%s\n",
    $precision, almkvist_giullera_pi($precision));
