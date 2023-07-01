use strict;
use warnings;
use feature 'say';

my $number   = '[+-/$]?(?:\.\d+|\d+(?:\.\d*)?)';
my $operator = '[-+*/^]';

my @tests = ('1 2 + 3 4 + ^ 5 6 + ^', '3 4 2 * 1 5 - 2 3 ^ ^ / +');

for (@tests) {
    my(@elems,$n);
    $n = -1;
    while (
        s/
            \s* (?<left>$number)   # 1st operand (will be 'left'  in infix)
            \s+ (?<right>$number)  # 2nd operand (will be 'right' in infix)
            \s+ (?<op>$operator)   # operator
            (?:\s+|$)              # more to parse, or done?
         /
            ' '.('$'.++$n).' '     # placeholders
         /ex) {
            $elems[$n] = "($+{left}$+{op}$+{right})"  # infix expression
         }
    while (
        s/ (\$)(\d+)    # for each placeholder
         / $elems[$2]   # evaluate expression, substitute numeric value
         /ex
        ) { say }       # track progress
    say '=>' . substr($_,2,-2)."\n";
}
