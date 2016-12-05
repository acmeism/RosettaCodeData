sub luhn-test ($number --> Bool) {
    my @digits = $number.comb.reverse;
    my $sum = @digits[0,2...*].sum
            + @digits[1,3...*].map({ |($_ * 2).comb }).sum;
    return $sum %% 10;
}
