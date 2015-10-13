my @happy = lazy gather for 1..* -> $number {
    my %stopper = 1 => 1;
    my $n = $number;
    repeat until %stopper{$n}++ {
        $n = [+] $n.comb X** 2;
    }
    take $number if $n == 1;
}

say ~@happy[^8];
