#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Sort_an_outline_at_every_level
use warnings;

for my $test ( split /^(?=#)/m, join '', <DATA> )
  {
  my ( $id, $outline ) = $test =~ /(\V*?\n)(.*)/s;
  my $sorted = validateandsort( $outline, $id =~ /descend/ );
  print $test, '=' x 20, " answer:\n$sorted\n";
  }

sub validateandsort
  {
  my ($outline, $descend) = @_;
  $outline =~ /^\h*(?: \t|\t )/m and
    return "ERROR: mixed tab and space indentaion\n";
  my $adjust = 0;
  $adjust++ while $outline =~ s/^(\h*)\H.*\n\1\K\h(?=\H)//m
    or $outline =~ s/^(\h*)(\h)\H.*\n\1\K(?=\H)/$2/m;
  $adjust and print "WARNING: adjusting indentation on some lines\n";
  return levelsort($outline, $descend);
  }

sub levelsort       # outline_section, descend_flag
  {
  my ($section, $descend) = @_;
  my @parts;
  while( $section =~ / ((\h*) .*\n) ( (?:\2\h.*\n)* )/gx )
    {
    my ($head, $rest) = ($1, $3);
    push @parts, $head . ( $rest and levelsort($rest, $descend) );
    }
  join '', $descend ? reverse sort @parts : sort @parts;
  }

__DATA__
# 4 space ascending
zeta
    beta
    gamma
        lambda
        kappa
        mu
    delta
alpha
    theta
    iota
    epsilon
# 4 space descending
zeta
    beta
    gamma
        lambda
        kappa
        mu
    delta
alpha
    theta
    iota
    epsilon

# mixed tab and space
alpha
    epsilon
  iota
    theta
zeta
    beta
    delta
    gamma
      kappa
        lambda
        mu
# off alignment
zeta
    beta
   gamma
        lambda
         kappa
        mu
    delta
alpha
    theta
    iota
    epsilon
