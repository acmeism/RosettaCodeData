for 1..5 {
    my $max = exp $_, 10;
    put "\n{+$_} odd squares from {$max / 10} to $max:\n{ .batch(10).join: "\n" }"
    given ({(2 × $++ + 1)²} … * > $max).grep: $max / 10 ≤ * ≤ $max
}
