#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Rational_calculator
use warnings;
use bigrat;

sub error { die s/\G/\e[91m<<@_>>\e[m/r }
sub want { /\G$_[1]/gc ? shift : error pop }
my $previous = 0;

sub expr
  {
  /\G\h+/gc;
  my $e =
    /\G\d+(?:\.\d+)?/gc ? 0 + $& : # insure $& treated as number
    /\G\@/gc ? $previous :
    /\G\(/gc ? want expr(0), qr/\)/, "Missing Close Paren" :
    /\G\+/gc ? expr(3) :
    /\G\-/gc ? -expr(3) :
    /\Gabs\b/gc ? abs expr(0) :
    error "Expected Operand";
  /\G\h+/gc, $e =
    $_[0] <= 3 && /\G\*\*/gc ? $e ** expr(3) :
    $_[0] <= 2 && /\G\*/gc   ? $e *  expr(3) :
    $_[0] <= 2 && /\G\//gc   ? $e /  expr(3) :
    $_[0] <= 1 && /\G\+/gc   ? $e +  expr(2) :
    $_[0] <= 1 && /\G\-/gc   ? $e -  expr(2) :
    return $e while 1;
  }

sub parse { want expr(0), "\n", "Incomplete Parse"; }

while( <DATA> ) # change to <> for interactive
  {
  print ">$_";
  $previous = eval{ parse() } or print($@), next;
  printf "=%s  (%g)\n", ($previous) x 2;
  }

__DATA__
1/3
4/8
4/7
1/25
7 +9 /@
3 - -15
@ ** 3
435 / -92
@ * -92
3 + (abs -4)
abs 3 + -15
2 * 3 + 4 * 5
2 + 3 * 4 + 5
42 / 2 ** 2 ** 8
0.333
1/4 + 1/6
1/4 + 1/5
(2/5) - (1/7)
1/2 + 1/3 + 1/4 + 1/5
1/2 + 1/3 + 1/4 + 1/5 + 1/6 + 1/7 + 1/8 + 1/9 + 1/10
1/2**2 + 1/3**2 + 1/4**2 + 1/5**2
1/2**1 + 1/2**2 + 1/2**3 + 1/2**4 + 1/2**5 + 1/2**6 + 1/2**7
-3 ** 4
(-3) ** 4
