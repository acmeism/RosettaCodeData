#!/usr/bin/perl

use strict;   # parse.pl - inputs lex, outputs flattened ast
use warnings; # http://www.rosettacode.org/wiki/Compiler/syntax_analyzer

my $h = qr/\G\s*\d+\s+\d+\s+/;  # header of each line

sub error { die "*** Expected @_ at " . (/\G(.*\n)/ ?
  $1 =~ s/^\s*(\d+)\s+(\d+)\s+/line $1 character $2 got /r : "EOF\n") }

sub want { /$h \Q$_[1]\E.*\n/gcx ? shift : error "'$_[1]'" }

local $_ = join '', <>;
print want stmtlist(), 'End_of_input';

sub stmtlist
  {
  /(?=$h (RightBrace|End_of_input))/gcx and return ";\n";
  my ($stmt, $stmtlist) = (stmt(), stmtlist());
  $stmtlist eq ";\n" ? $stmt : "Sequence\n$stmt$stmtlist";
  }

sub stmt
  {
  /$h Semicolon\n/gcx ? ";\n" :
    /$h Identifier \s+ (\w+) \n/gcx ? want("Assign\nIdentifier\t$1\n",
      'Op_assign') . want expr(0), 'Semicolon' :
    /$h Keyword_while \n/gcx ? "While\n" . parenexp() . stmt() :
    /$h Keyword_if \n/gcx ?  "If\n" . parenexp() . "If\n" . stmt() .
      (/$h Keyword_else \n/gcx ? stmt() : ";\n") :
    /$h Keyword_print \n/gcx ? want('', 'LeftParen') .
      want want(printlist(), 'RightParen'), 'Semicolon' :
    /$h Keyword_putc \n/gcx ? want "Prtc\n" . parenexp() . ";\n", 'Semicolon' :
    /$h LeftBrace \n/gcx ? want stmtlist(), 'RightBrace' :
    error 'A STMT';
  }

sub parenexp { want('', 'LeftParen') . want expr(0), 'RightParen' } # (expr)

sub printlist
  {
  my $ast = /$h String \s+ (".*") \n/gcx ?
    "Prts\nString\t\t$1\n;\n" : "Prti\n" . expr(0) . ";\n";
  /$h Comma \n/gcx ? "Sequence\n$ast" . printlist() : $ast;
  }

sub expr               # (sort of EBNF) expr = operand { operator expr }
  {
  my $ast =                                        # operand
    /$h Integer \s+ (\d+) \n/gcx ? "Integer\t\t$1\n" :
    /$h Identifier \s+ (\w+) \n/gcx ? "Identifier\t$1\n" :
    /$h LeftParen \n/gcx ? want expr(0), 'RightParen' :
    /$h Op_(negate|subtract) \n/gcx ? "Negate\n" . expr(8) . ";\n" :
    /$h Op_not \n/gcx ? "Not\n" . expr(8) . ";\n" :
    /$h Op_add \n/gcx ? expr(8) :
    error "A PRIMARY";
  $ast =                                           # { operator expr }
    $_[0] <= 7 && /$h Op_multiply \n/gcx ? "Multiply\n$ast" . expr(8) :
    $_[0] <= 7 && /$h Op_divide \n/gcx ? "Divide\n$ast" . expr(8) :
    $_[0] <= 7 && /$h Op_mod \n/gcx ? "Mod\n$ast" . expr(8) :
    $_[0] <= 6 && /$h Op_add \n/gcx ? "Add\n$ast" . expr(7) :
    $_[0] <= 6 && /$h Op_subtract \n/gcx ? "Subtract\n$ast" . expr(7) :
    $_[0] == 5 && /(?=$h Op_(less|greater)(equal)? \n)/gcx ? error 'NO ASSOC' :
    $_[0] <= 5 && /$h Op_lessequal \n/gcx ? "LessEqual\n$ast" . expr(5) :
    $_[0] <= 5 && /$h Op_less \n/gcx ? "Less\n$ast" . expr(5) :
    $_[0] <= 5 && /$h Op_greater \n/gcx ? "Greater\n$ast" . expr(5) :
    $_[0] <= 5 && /$h Op_greaterequal \n/gcx ?  "GreaterEqual\n$ast" . expr(5) :
    $_[0] == 3 && /(?=$h Op_(not)?equal \n)/gcx ? error 'NO ASSOC' :
    $_[0] <= 3 && /$h Op_equal \n/gcx ? "Equal\n$ast" . expr(3) :
    $_[0] <= 3 && /$h Op_notequal \n/gcx ? "NotEqual\n$ast" . expr(3) :
    $_[0] <= 1 && /$h Op_and \n/gcx ? "And\n$ast" . expr(2) :
    $_[0] <= 0 && /$h Op_or \n/gcx ? "Or\n$ast" . expr(1) :
    return $ast while 1;
  }
