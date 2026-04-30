#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Tropical_algebra_overloading
use warnings;

#Show that 2 * -2 is 0, -0.001 + -Inf is -0.001, 0 * -Inf is -Inf, 1.5 + -1 is 1.5, and -0.5 * 0 is -0.5.

my $negativeinfinity = - 2 ** 2 ** 10;
print "negativeinfinity $negativeinfinity\n";
printf "2 * -2 is %s\n", Tropical->new(2) * -2;
printf "-0.001 + -inf is %s\n", Tropical->new(0.001) + $negativeinfinity;
printf "0 * -inf is %s\n", Tropical->new(0) * $negativeinfinity;
printf "1.5 + -1 is %s\n", Tropical->new(1.5) + -1;
printf "-0.5 * 0 is %s\n", Tropical->new(-0.5) * 0;
printf "2 ** 3 is %s\n", Tropical->new(2) ** 3;
printf "2 ** 3 is %s\n", 2 ** Tropical->new(3);
printf "5 * ( 8 + 7) is %s\n", 5 * (Tropical->new(8) + 7);
printf "5 * 8 + 5 * 7 is %s\n", 5 * Tropical->new(8) + Tropical->new(5) * 7;

package Tropical;
use overload qw( "" asstring + add ** power * mult  );
use List::Util qw( max );

sub new
  {
  my ( $class, $value ) = @_;
  bless \$value, ref $class || $class;
  }

sub asstring
  {
  my ($self, $other, $swap) = @_;
  $$self;
  }

sub add
  {
  my ($self, $other, $swap) = @_;
  return $swap
    ? bless \(max "$other", $$self), ref $self
    : bless \(max $$self, "$other"), ref $self;
  }

sub mult
  {
  my ($self, $other, $swap) = @_;
  return $swap
    ? bless \("$other" + $$self), ref $self
    : bless \($$self + "$other"), ref $self;
  }

sub power
  {
  my ($self, $other, $swap) = @_;
  return $swap
    ? bless \("$other" * $$self), ref $self
    : bless \($$self * "$other"), ref $self;
  }
