use strict;
use warnings;
use Math::AnyNum;

sub ramanujan_const {
    my ($x, $decimals) = @_;

    $x = Math::AnyNum->new($x);
    my $prec = (Math::AnyNum->pi * $x->sqrt)/log(10) + $decimals + 1;
    local $Math::AnyNum::PREC = 4*$prec->round->numify;

    exp(Math::AnyNum->pi * $x->sqrt)->round(-$decimals)->stringify;
}

my $decimals = 100;
printf("Ramanujan's constant to $decimals decimals:\n%s\n\n",
    ramanujan_const(163, $decimals));

print "Heegner numbers yielding 'almost' integers:\n";
my @tests = (19, 96, 43, 960, 67, 5280, 163, 640320);

while (@tests) {
    my ($h, $x) = splice(@tests, 0, 2);
    my $c = ramanujan_const($h, 32);
    my $n = Math::AnyNum::ipow($x, 3) + 744;
    printf("%3s: %51s ≈ %18s (diff: %s)\n", $h, $c, $n, ($n - $c)->round(-32));
}
