#!/usr/bin/perl -w
use strict;

use PDL;
use PDL::Math;
use PDL::Fit::Polynomial;

my $x = float [0,  1,  2,  3,  4,  5,  6,   7,   8,   9,   10];
my $y = float [1,  6,  17, 34, 57, 86, 121, 162, 209, 262, 321];
# above will output:  3.00000037788248 * $x**2 + 1.99999750988868 * $x + 1.00000180493936

# $x = float [ 0,   1,   2,    3,    4,    5,    6,     7,     8,     9];
# $y = float [ 2.7, 2.8, 31.4, 38.1, 58.0, 76.2, 100.5, 130.0, 149.3, 180.0];
# above correctly returns: " 1.08484845125187 * $x**2 + 10.3551513321297 * $x-0.616363852007752 "

my ($yfit, $coeffs) = fitpoly1d $x, $y, 3;      # 3rd degree

foreach (reverse(0..$coeffs->dim(0)-1)) {
  print " +" unless(($coeffs->at($_) <0) || $_==$coeffs->dim(0)-1); # let the unary minus replace the + operator
  print " ";
  print $coeffs->at($_);
  print " * \$x" if($_);
  print "**$_" if($_>1);
  print "\n" unless($_)
}
