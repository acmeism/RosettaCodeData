# 20241003 Perl programming solution

use strict;
use warnings;

sub Y {
   my ($a) = @_;
   [ map { my $f = $_; sub { $f->(Y($a)) } } @$a ]
}

my $even_odd_fix = [
   sub { my ($f) = @_; sub { my ($n) = @_; $n == 0 || $f->[1]->()->($n - 1) } },
   sub { my ($f) = @_; sub { my ($n) = @_; $n != 0 && $f->[0]->()->($n - 1) } },
];

my $collatz_fix = [
   sub { my ($f) = @_; sub { my ($n,$d) = @_; $n == 1 ? $d : $f->[($n % 2) + 1]->()->($n, $d + 1) } },
   sub { my ($f) = @_; sub { my ($n,$d) = @_; $f->[0]->()->(int($n/2), $d)  } },
   sub { my ($f) = @_; sub { my ($n,$d) = @_; $f->[0]->()->(3 * $n + 1, $d) } },
];

my $even_odd = [ map { $_->() } @{Y $even_odd_fix} ];
my $collatz  = Y($collatz_fix)->[0]->();

for my $i (1..10) {
   my $e = $even_odd->[0]->($i);
   my $o = $even_odd->[1]->($i);
   my $c = $collatz->($i, 0);
   printf "%2d: Even: %5s  Odd: %5s  Collatz: %2d\n", $i, $e ? 'True' : 'False', $o ? 'True' : 'False', $c;
}
