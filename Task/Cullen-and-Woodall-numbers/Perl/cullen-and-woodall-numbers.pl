use strict;
use warnings;
use bigint;
use ntheory 'is_prime';
use constant Inf  => 1e10;

sub cullen {
    my($n,$c) = @_;
    ($n * 2**$n) + $c;
}

my($m,$n);

($m,$n) = (20,0);
print "First $m Cullen numbers:\n";
print do { $n < $m ? (++$n and cullen($_,1) . ' ') : last } for 1 .. Inf;

($m,$n) = (20,0);
print "\n\nFirst $m Woodall numbers:\n";
print do { $n < $m ? (++$n and cullen($_,-1) . ' ') : last } for 1 .. Inf;

($m,$n) = (5,0);
print "\n\nFirst $m Cullen primes: (in terms of n)\n";
print do { $n < $m ? (!!is_prime(cullen $_,1) and ++$n and "$_ ") : last } for 1 .. Inf;

($m,$n) = (12,0);
print "\n\nFirst $m Woodall primes: (in terms of n)\n";
print do { $n < $m ? (!!is_prime(cullen $_,-1) and ++$n and "$_ ") : last } for 1 .. Inf;
