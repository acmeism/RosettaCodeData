my @v = <9 8 7 6 5 0 1 2 3 4>;
say map { select(@v, $_) }, 1 .. 10;

sub partition(@vector, $left, $right, $pivot-index) {
    my $pivot-value = @vector[$pivot-index];
    @vector[$pivot-index, $right] = @vector[$right, $pivot-index];
    my $store-index = $left;
    for $left ..^ $right -> $i {
        if @vector[$i] < $pivot-value {
            @vector[$store-index, $i] = @vector[$i, $store-index];
            $store-index++;
        }
    }
    @vector[$right, $store-index] = @vector[$store-index, $right];
    return $store-index;
}

sub select( @vector,
            \k where 1 .. @vector,
            \l where 0 .. @vector = 0,
            \r where l .. @vector = @vector.end ) {

    my ($k, $left, $right) = k, l, r;

    loop {
        my $pivot-index = ($left..$right).pick;
        my $pivot-new-index = partition(@vector, $left, $right, $pivot-index);
        my $pivot-dist = $pivot-new-index - $left + 1;
        given $pivot-dist <=> $k {
            when Same {
                return @vector[$pivot-new-index];
            }
            when Decrease {
                $right = $pivot-new-index - 1;
            }
            when Increase {
                $k -= $pivot-dist;
                $left = $pivot-new-index + 1;
            }
        }
    }
}
