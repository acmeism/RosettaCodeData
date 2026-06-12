my atomicint $index = 0;
my @prime-measure = 1;

for 2..* -> $next {
    my atomicint $last;
    (0..$index-1).hyper(:10batch).map: -> $start {
        for 1..$index -> $end {
            next if $start == $end;
            last if $next < my $sum = @prime-measure[$start..$end].sum;
            ++⚛$last and last if $sum == $next;
        }
        last if $last
    }
    next if $last;
    @prime-measure.push: $next;
    ++⚛$index;
    last if $index >= 999;
}

put "First 100:\n", @prime-measure[^100]».fmt('%3d').batch(10).join: "\n";

put "\nOne Thousandth: ", @prime-measure.tail;
