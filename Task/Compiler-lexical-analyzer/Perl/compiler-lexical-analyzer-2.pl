#!/usr/bin/perl

use strict;   # lex.pl - source to tokens
use warnings; # http://www.rosettacode.org/wiki/Compiler/lexical_analyzer
no warnings qw(qw);

my %keywords = map { $_, "Keyword_$_" } qw( while print if else putc );
my %tokens = qw[ ; Semicolon ( LeftParen ) RightParen { LeftBrace } RightBrace
  + Op_add - Op_subtract * Op_multiply % Op_mod = Op_assign >= Op_greaterequal
  != Op_notequal == Op_equal ! Op_not < Op_less <= Op_lessequal > Op_greater
  , Comma && Op_and || Op_or ];

local $_ = join '', <>;

while( /\G (?|
    \s+              (?{ undef })
  | \d+[_a-zA-Z]\w*  (?{ die "invalid mixed number $&\n" })
  | \d+              (?{ "Integer $&" })
  | \w+              (?{ $keywords{$&} || "Identifier $&" })
  | ( [-;(){}+*%,] | [=!<>]=? | && | \|\| )
                     (?{ $tokens{$1} })
  | \/               (?{ 'Op_divide' }) (?: \* (?: [\s\S]*?\*\/ (?{ undef }) |
                          (?{ die "End-of-file in comment\n" }) ) )?
  | "[^"\n]*"        (?{ "String $&" })
  | "                (?{ die "unterminated string\n" })
  | ''               (?{ die "empty character constant\n" })
  | '([^\n\\])'      (?{ 'Integer ' . ord $1 })
  | '\\n'            (?{ 'Integer 10' })
  | '\\\\'           (?{ 'Integer 92' })
  | '                (?{ die "unterminated or bad character constant\n" }) #'
  | .                (?{ die "invalid character $&\n" })
  ) /gcx )
  {
  defined $^R and printf "%5d %7d   %s\n",
    1 + $` =~ tr/\n//, 1 + length $` =~ s/.*\n//sr, $^R;
  }
printf "%5d %7d   %s\n", 1 + tr/\n//, 1, 'End_of_input';
