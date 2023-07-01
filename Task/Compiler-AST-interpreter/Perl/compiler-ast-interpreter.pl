#!/usr/bin/perl

use strict;   # interpreter.pl - execute a flatAST
use warnings; # http://www.rosettacode.org/wiki/Compiler/AST_interpreter
use integer;

my %variables;

tree()->run;

sub tree
  {
  my $line = <> // die "incomplete tree\n";
  (local $_, my $arg) = $line =~ /^(\w+|;)\s+(.*)/ or die "bad input $line";
  /String/ ? bless [$arg =~ tr/""//dr =~ s/\\(.)/$1 eq 'n' ? "\n" : $1/ger], $_ :
    /Identifier|Integer/ ? bless [ $arg ], $_ :
    /;/ ? bless [], 'Null' :
    bless [ tree(), tree() ], $_;
  }

sub Add::run { $_[0][0]->run + $_[0][1]->run }
sub And::run { $_[0][0]->run && $_[0][1]->run }
sub Assign::run { $variables{$_[0][0][0]} = $_[0][1]->run }
sub Divide::run { $_[0][0]->run / $_[0][1]->run }
sub Equal::run { $_[0][0]->run == $_[0][1]->run ? 1 : 0 }
sub Greater::run { $_[0][0]->run > $_[0][1]->run ? 1 : 0 }
sub GreaterEqual::run { $_[0][0]->run >= $_[0][1]->run ? 1 : 0 }
sub Identifier::run { $variables{$_[0][0]} // 0 }
sub If::run { $_[0][0]->run ? $_[0][1][0]->run : $_[0][1][1]->run }
sub Integer::run { $_[0][0] }
sub Less::run { $_[0][0]->run < $_[0][1]->run ? 1 : 0 }
sub LessEqual::run { $_[0][0]->run <= $_[0][1]->run ? 1 : 0 }
sub Mod::run { $_[0][0]->run % $_[0][1]->run }
sub Multiply::run { $_[0][0]->run * $_[0][1]->run }
sub Negate::run { - $_[0][0]->run }
sub Not::run { $_[0][0]->run ? 0 : 1 }
sub NotEqual::run { $_[0][0]->run != $_[0][1]->run ? 1 : 0 }
sub Null::run {}
sub Or::run { $_[0][0]->run || $_[0][1]->run }
sub Prtc::run { print chr $_[0][0]->run }
sub Prti::run { print $_[0][0]->run }
sub Prts::run { print $_[0][0][0] }
sub Sequence::run { $_->run for $_[0]->@* }
sub Subtract::run { $_[0][0]->run - $_[0][1]->run }
sub While::run { $_[0][1]->run while $_[0][0]->run }
