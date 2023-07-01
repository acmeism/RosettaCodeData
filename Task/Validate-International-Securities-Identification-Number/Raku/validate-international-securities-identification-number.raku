my $ISIN = /
    ^ <[A..Z]>**2 <[A..Z0..9]>**9 <[0..9]> $
    <?{ luhn-test $/.comb.map({ :36($_) }).join }>
/;

sub luhn-test ($number --> Bool) {
    my @digits = $number.comb.reverse;
    my $sum = @digits[0,2...*].sum
            + @digits[1,3...*].map({ |($_ * 2).comb }).sum;
    return $sum %% 10;
}

# Testing:

say "$_ is { m/$ISIN/ ?? "valid" !! "not valid"}" for <
US0378331005
US0373831005
U50378331005
US03378331005
AU0000XVGZA3
AU0000VXGZA3
FR0000988040
>;
