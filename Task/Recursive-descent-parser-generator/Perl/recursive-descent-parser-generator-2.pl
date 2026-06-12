#!/usr/bin/perl
use strict; # https://rosettacode.org/wiki/Recursive_descent_parser_generator
use warnings; # WARNING: this code is generated

my @stack;
my $whitespace = qr/\s*/;

my $grammar = <<'GRAMMAR'; # make grammar rules available to usercode
expr = term { plus term <gen3addr> } .
term = factor { times factor <gen3addr> } .
factor = primary [ '^' factor <gen3addr> ] .
primary = '(' expr ')' <removeparens> | NAME .
plus = "+" | "-" .
times = "*" | "/" .
GRAMMAR

#usercode -- separator for included code for actions

my $temp = '0000';

sub begin { print "parsing: $_\n\n" }

sub gen3addr
  {
  @stack >= 3 or die "not enough on stack";
  my @three = splice @stack, -3, 3, my $t = '_' . ++$temp;
  print "$t = @three\n";
  }

sub removeparens
  {
  @stack >= 3 or die "not enough on stack";
  splice @stack, -3, 3, $stack[-2];
  }
#end usercode

# generated code (put in Rule:: package)

sub Rule::expr
  {
  ( # seq
  Rule::term() and
  do { # repeat
  1 while ( # seq
  Rule::plus() and
  Rule::term() and
  ( gen3addr() || 1 ) ) ; 1 } )
  }

sub Rule::factor
  {
  ( # seq
  Rule::primary() and
  ( # option
  ( # seq
  ( /\G$whitespace(\^)/gc and push @stack, $1 ) and
  Rule::factor() and
  ( gen3addr() || 1 ) ) or 1 ) )
  }

sub Rule::plus
  {
  ( # alt
  ( /\G$whitespace(\+)/gc and push @stack, $1 ) or
  ( /\G$whitespace(\-)/gc and push @stack, $1 ) )
  }

sub Rule::primary
  {
  ( # alt
  ( # seq
  ( /\G$whitespace(\()/gc and push @stack, $1 ) and
  Rule::expr() and
  ( /\G$whitespace(\))/gc and push @stack, $1 ) and
  ( removeparens() || 1 ) ) or
  ( /\G$whitespace(\w+)/gc and push @stack, $1 ) )
  }

sub Rule::startsymbol
  {
  Rule::expr()
  }

sub Rule::term
  {
  ( # seq
  Rule::factor() and
  do { # repeat
  1 while ( # seq
  Rule::times() and
  Rule::factor() and
  ( gen3addr() || 1 ) ) ; 1 } )
  }

sub Rule::times
  {
  ( # alt
  ( /\G$whitespace(\*)/gc and push @stack, $1 ) or
  ( /\G$whitespace(\/)/gc and push @stack, $1 ) )
  }

# preceding code was generated for rules

local $_ = shift // '(one + two) * three - four * five';
eval { begin() };                           # eval because it is optional
Rule::startsymbol();
eval { end() };                             # eval because it is optional
/\G\s*\z/ or die "ERROR: incomplete parse\n";
