use strict;
use warnings;
use feature 'say';
use utf8;
binmode(STDOUT, ':utf8');
use List::AllUtils 'before';
use ntheory qw<is_prime factorial>;

sub is_erdos {
    my($n) = @_; my $k;
    return unless is_prime($n);
    while ($n > factorial($k++)) { return if is_prime $n-factorial($k) }
    'True'
}

my(@Erdős,$n);
do { push @Erdős, $n if is_erdos(++$n) } until $n >= 1e6;

say 'Erdős primes < ' . (my $max = 2500) . ':';
say join ' ', before { $_ > 2500 } @Erdős;
say "\nErdős prime #" . @Erdős . ' is ' . $Erdős[-1];
