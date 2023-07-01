my @squares = ^∞ .map: *²; # Infinite series of squares

for 1..∞ -> $sq {          # for every combination of all squares
    my @sums = @squares[^$sq].combinations».sum.unique.sort;
    my @run;
    for @sums {
        @run.push($_) and next unless @run.elems;
        if $_ == @run.tail + 1 { @run.push: $_ } else { last if @run.elems > @squares[$sq]; @run = () }
    }
    put grep * ∉ @sums, 1..@run.tail and last if @run.elems > @squares[$sq];
}
