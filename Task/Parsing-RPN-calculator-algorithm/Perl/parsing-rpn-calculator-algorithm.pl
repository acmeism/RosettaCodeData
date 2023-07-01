use strict;
use warnings;
use feature 'say';

my $number   = '[+-]?(?:\.\d+|\d+(?:\.\d*)?)';
my $operator = '[-+*/^]';

my @tests = ('3 4 2 * 1 5 - 2 3 ^ ^ / +');

for (@tests) {
    while (
        s/ \s* ((?<left>$number))     # 1st operand
           \s+ ((?<right>$number))    # 2nd operand
           \s+ ((?<op>$operator))     # operator
           (?:\s+|$)                  # more to parse, or done?
         /
           ' '.evaluate().' '         # substitute results of evaluation
         /ex
    ) {}
    say;
}

sub evaluate {
  (my $a = "($+{left})$+{op}($+{right})") =~ s/\^/**/;
  say $a;
  eval $a;
}
