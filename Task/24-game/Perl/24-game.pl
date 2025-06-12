#!/usr/bin/env perl
use warnings;
use strict;
use feature 'say';

print <<'EOF';
The 24 Game

Given any four digits in the range 1 to 9, which may have repetitions,
Using just the +, -, *, and / operators; and the possible use of
parentheses, (), show how to make an answer of 24.

An answer of "q" or EOF will quit the game.
A blank answer will generate a new set of four digits.
Otherwise you are repeatedly asked for an expression until it evaluates to 24.

Note: you cannot form multiple digit numbers from the supplied digits,
so an answer of 12+12 when given 1, 2, 2, and 1 would not be allowed.
EOF

my $try = 1;
while (1) {
  my @digits = map { 1+int(rand(9)) } 1..4;
  say "\nYour four digits: ", join(" ", @digits);
  print "Expression (try ", $try++, "): ";

  my $entry = <>;
  if (!defined $entry || substr($entry,0,1) eq 'q')
    { say "Goodbye.  Sorry you couldn't win."; last; }
  $entry =~ s/\s+//g;  # remove all white space (newline is whitespace too)
  next if $entry eq '';

  my $given_digits = join "", sort @digits;
  my $entry_digits = join "", sort grep { /\d/ } split(//, $entry);
  if ($given_digits ne $entry_digits)
   { say "incorrect digits"; next; }
  if ($entry =~ /\d\d/)
    { say "error, combined digits"; next; }
  if ($entry =~ m|[-+*/]{2}|)
    { say "error, combined operators"; next; }
  if ($entry =~ tr|-0-9()+*/||c)
    { say "invalid characters!"; next; }

  my $n = eval $entry;

  if    (!defined $n) { say "Invalid expression"; }
  elsif ($n == 24)    { say "You win!"; last; }
  else                { say "Sorry, your expression is $n, not 24"; }
}
