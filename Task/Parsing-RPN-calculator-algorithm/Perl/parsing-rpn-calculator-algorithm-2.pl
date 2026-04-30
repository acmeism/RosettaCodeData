#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Parsing/RPN_calculator_algorithm
use warnings;
use Text::ASCIITable;

while( <DATA> )
  {
  my $table = Text::ASCIITable->new({headingText => $_});
  $table->setCols(qw(Token Stack));
  $table->alignCol({Token => 'center', Stack => 'left'});
  my @stack;
  for ( split )
    {
    /\d/ ? push @stack, $_ : splice @stack, -2, 2,
      /\+/ ? $stack[-2] +  $stack[-1] :
      /\-/ ? $stack[-2] -  $stack[-1] :
      /\*/ ? $stack[-2] *  $stack[-1] :
      /\// ? $stack[-2] /  $stack[-1] :
             $stack[-2] ** $stack[-1];
    $table->addRow( $_, "@stack" );
    }
  print $table;
  }

__DATA__
3 4 2 * 1 5 - 2 3 ^ ^ / +
