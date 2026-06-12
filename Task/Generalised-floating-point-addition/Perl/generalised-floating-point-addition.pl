use strict;
use warnings;
use Math::Decimal qw(dec_add dec_mul_pow10);

my $e = 63;
for my $n (-7..21) {
    my $num = '12345679' . '012345679' x ($n+7);
    my $sum = dec_mul_pow10(1, $e);
    $sum = dec_add($sum, dec_mul_pow10($num,$e)) for 1..81;
    printf "$n:%s ", 10**72 == $sum ? 'Y' : 'N';
    $e -= 9;
}
