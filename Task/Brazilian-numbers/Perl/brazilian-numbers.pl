use strict;
use warnings;
use ntheory qw<is_prime>;
use constant Inf  => 1e10;

sub is_Brazilian {
    my($n) = @_;
    return 1 if $n > 6 && 0 == $n%2;
    LOOP: for (my $base = 2; $base < $n - 1; ++$base) {
        my $digit;
        my $nn = $n;
        while (1) {
            my $x = $nn % $base;
            $digit //= $x;
            next LOOP if $digit != $x;
            $nn = int $nn / $base;
            if ($nn < $base) {
                return 1 if $digit == $nn;
                next LOOP;
            }
        }
    }
}

my $upto = 20;

print "First $upto Brazilian numbers:\n";
my $n = 0;
print do { $n < $upto ? (is_Brazilian($_) and ++$n and "$_ ") : last } for 1 .. Inf;

print "\n\nFirst $upto odd Brazilian numbers:\n";
$n = 0;
print do { $n < $upto ? (!!($_%2) and is_Brazilian($_) and ++$n and "$_ ") : last } for 1 .. Inf;

print "\n\nFirst $upto prime Brazilian numbers:\n";
$n = 0;
print do { $n < $upto ? (!!is_prime($_) and is_Brazilian($_) and ++$n and "$_ ") : last } for 1 .. Inf;
