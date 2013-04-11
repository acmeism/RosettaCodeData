sub luhn-test ($cc-number --> Bool) {
    my @digits = $cc-number.comb.reverse;
    my $s1 = [+] @digits[0,2...@digits.end];
    my $s2 = [+] @digits[1,3...@digits.end].map({[+] ($^a * 2).comb});

    return ($s1 + $s2) %% 10;
}
