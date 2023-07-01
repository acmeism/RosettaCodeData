(3..8).map: -> $p {
    my %pow = (^10).map: { $_ => $_ ** $p };
    my $start = 10 ** ($p - 1);
    my $end   = 10 ** $p;
    my @temp;
    for ^9 -> $i {
        ([X] ($i..9) xx $p).race.map: {
            next unless [<=] $_;
            my $sum = %pow{$_}.sum;
            next if $sum < $start;
            next if $sum > $end;
            @temp.push: $sum if $sum.comb.Bag eqv $_».Str.Bag
        }
    }
    .say for unique sort @temp;
}
