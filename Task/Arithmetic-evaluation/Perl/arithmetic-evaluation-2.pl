#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Arithmetic_evaluation
use warnings;

sub node { bless [ splice @_, 1 ], shift }
sub error { die s/\G.*//sr =~ tr/\t/ /cr, "^ @_ !\n" }
sub want { /\G$_[1]/gc ? shift : error pop }

sub expr
  {
  /\G\h+/gc;
  my $ast =
    /\G\d+/gc ? node NUMBER => $& :
    /\G\(/gc  ? want expr(0), qr/\)/, 'Missing Right Paren' :
    error 'Operand Expected';
  /\G\h+/gc, $ast =
    $_[0] <= 0 && /\G\+/gc ? node      ADD => $ast, expr(1) :
    $_[0] <= 0 && /\G\-/gc ? node SUBTRACT => $ast, expr(1) :
    $_[0] <= 1 && /\G\*/gc ? node MULTIPLY => $ast, expr(2) :
    $_[0] <= 1 && /\G\//gc ? node   DIVIDE => $ast, expr(2) :
    return $ast while 1;
  }

sub      ADD::value { $_[0][0]->value + $_[0][1]->value }
sub SUBTRACT::value { $_[0][0]->value - $_[0][1]->value }
sub MULTIPLY::value { $_[0][0]->value * $_[0][1]->value }
sub   DIVIDE::value { $_[0][0]->value / $_[0][1]->value }
sub   NUMBER::value { $_[0][0] }

sub    NUMBER::show { "$_[0][0]\n" }
sub UNIVERSAL::show
  { ref($_[0]) . "\n" . join('', map $_->show, @{$_[0]}) =~ s/^/    /gmr }

while( <DATA> )
  {
  eval
    {
    print;
    my $ast = want expr(0), "\n", 'Incomplete Parse';
    print $ast->show, "value of ast = ", $ast->value, "\n\n";
    } or print "$@\n";
  }

__DATA__
(1+3)*7
2 * 3 + 4 * 5
2 + 3 * 4 + 5
2 + 3 ** 4 + 5
