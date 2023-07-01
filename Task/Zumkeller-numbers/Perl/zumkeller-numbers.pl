use strict;
use warnings;
use feature 'say';
use ntheory <is_prime divisor_sum divisors vecsum forcomb lastfor>;

sub in_columns {
    my($columns, $values) = @_;
    my @v = split ' ', $values;
    my $width = int(80/$columns);
    printf "%${width}d"x$columns."\n", @v[$_*$columns .. -1+(1+$_)*$columns] for 0..-1+@v/$columns;
    print "\n";
}

sub is_Zumkeller {
    my($n) = @_;
    return 0 if is_prime($n);
    my @divisors = divisors($n);
    return 0 unless @divisors > 2 && 0 == @divisors % 2;
    my $sigma = divisor_sum($n);
    return 0 unless 0 == $sigma%2 && ($sigma/2) >= $n;
    if (1 == $n%2) {
        return 1
    } else {
        my $Z = 0;
        forcomb { $Z++, lastfor if vecsum(@divisors[@_]) == $sigma/2 } @divisors;
        return $Z;
    }
}

use constant Inf  => 1e10;

say 'First 220 Zumkeller numbers:';
my $n = 0; my $z;
$z .= do { $n < 220 ? (is_Zumkeller($_) and ++$n and "$_ ") : last } for 1 .. Inf;
in_columns(20, $z);

say 'First 40 odd Zumkeller numbers:';
$n = 0; $z = '';
$z .= do { $n < 40 ? (!!($_%2) and is_Zumkeller($_) and ++$n and "$_ ") : last } for 1 .. Inf;
in_columns(10, $z);

say 'First 40 odd Zumkeller numbers not divisible by 5:';
$n = 0; $z = '';
$z .= do { $n < 40 ? (!!($_%2 and $_%5) and is_Zumkeller($_) and ++$n and "$_ ") : last } for 1 .. Inf;
in_columns(10, $z);
