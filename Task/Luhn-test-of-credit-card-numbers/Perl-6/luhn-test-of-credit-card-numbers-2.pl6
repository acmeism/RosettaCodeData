use Test;

my %cc-numbers =
    '49927398716'       => True,
    '49927398717'       => False,
    '1234567812345678'  => False,
    '1234567812345670'  => True;

plan %cc-numbers.elems;

for %cc-numbers.kv -> $cc, $expected-result {
    is luhn-test(+$cc), $expected-result,
        "$cc {$expected-result ?? 'passes' !! 'does not pass'} the Luhn test.";
}
