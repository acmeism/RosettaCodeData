#!/usr/bin/perl

use strict; # http://www.rosettacode.org/wiki/Compiler/_Verifying_Syntax
use warnings;

sub error
  {
  my $pos = pos($_) // 0;
  die $_, ' ' x ($pos + 7), "^ $_[0]\n";
  }
sub want { /\G\Q$_[0]/gc or error $_[1] }

sub expr
  {
  my $level = shift;
  /\G\h+/gc;
  /\G\(/gc && want ')', "expected a closing paren", expr(0) or
    $level <= 4 && /\Gnot\b/gc && expr(5) or
    /\G (?!(?:and|or|not)\b) (?:\d+|[a-zA-Z]\w*)/gcx or
    error "expected a primary";
  /\G\h+/gc ? 1 :
    $level <= 2   && /\Gor\b/gc     ? expr(3) :
    $level <= 3   && /\Gand\b/gc    ? expr(4) :
    $level <= 4   && /\G[=<]/gc     ? expr(4.5) :
    $level == 4.5 && /\G(?=[=<])/gc ? error "non-associative operator" :
    $level <= 5   && /\G[+-]/gc     ? expr(6) :
    $level <= 6   && /\G[*\/]/gc    ? expr(7) :
    return 1 while 1;
  }

while( <DATA> )
  {
  print eval { want "\n", "expected end of input", expr(0) } ?
    " true  $_" : "false  $@";
  }

__DATA__
3 + not 5
3 + (not 5)
(42 + 3
(42 + 3 syntax_error
not 3 < 4 or (true or 3/4+8*5-5*2 < 56) and 4*3 < 12 or not true
and 3 < 2
not 7 < 2
2 < 3 < 4
2 < foobar - 3 < 4
2 < foobar and 3 < 4
4 * (32 - 16) + 9 = 73
235 76 + 1
a + b = not c and false
a + b = (not c) and false
a + b = (not c and false)
ab_c / bd2 or < e_f7
g not = h
i++
j & k
l or _m
UPPER_cAsE_aNd_letter_and_12345_test
