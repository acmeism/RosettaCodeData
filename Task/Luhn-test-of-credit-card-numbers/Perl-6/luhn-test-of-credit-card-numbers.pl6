sub luhn-test ($number --> Bool) {
    my @digits = $number.comb.reverse;
    my $sum = @digits[0,2...*].sum
            + @digits[1,3...*].map({ |($_ * 2).comb }).sum;
    return $sum %% 10;
}

# And we can test it like this:

use Test;

my @cc-numbers =
    '49927398716'       => True,
    '49927398717'       => False,
    '1234567812345678'  => False,
    '1234567812345670'  => True;

plan @cc-numbers.elems;

for @cc-numbers».kv -> ($cc, $expected-result) {
    is luhn-test(+$cc), $expected-result,
        "$cc {$expected-result ?? 'passes' !! 'does not pass'} the Luhn test.";
}
