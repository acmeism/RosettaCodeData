constant @cu = (^Inf).map: { .³ }

sub MAIN ($start = 1, $end = 25) {
    my %taxi;
    my int $taxis = 0;
    my $terminate = 0;
    my int $max = 0;

    for 1 .. * -> $c1 {
        last if ?$terminate && ($terminate < $c1);
        for 1 .. $c1 -> $c2 {
            my $this = @cu[$c1] + @cu[$c2];
            %taxi{$this}.push: [$c2, $c1];
            if %taxi{$this}.elems == 2 {
                ++$taxis;
                $max max= $this;
            }
    	    $terminate = ceiling $max ** (1/3) if $taxis == $end and !$terminate;
        }
    }

    display( %taxi, $start, $end );

}

sub display (%this_stuff, $start, $end) {
    my $i = $start;
    printf "%4d %10d  =>\t%s\n", $i++, $_.key,
        (.value.map({ sprintf "%4d³ + %-s\³", |$_ })).join: ",\t"
        for %this_stuff.grep( { $_.value.elems > 1 } ).sort( +*.key )[$start-1..$end-1];
}
