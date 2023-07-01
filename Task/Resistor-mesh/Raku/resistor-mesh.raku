my $*TOLERANCE = 1e-12;

sub set-boundary(@mesh,@p1,@p2) {
    @mesh[ @p1[0] ; @p1[1] ] =  1;
    @mesh[ @p2[0] ; @p2[1] ] = -1;
}

sub solve(@p1, @p2, Int \w, Int \h) {
    my @d     = [0 xx w] xx h;
    my @V     = [0 xx w] xx h;
    my @fixed = [0 xx w] xx h;
    set-boundary(@fixed,@p1,@p2);

    loop {
        set-boundary(@V,@p1,@p2);
        my $diff = 0;
        for (flat ^h X ^w) -> \i, \j {
            my @neighbors = (@V[i-1;j], @V[i;j-1], @V[i+1;j], @V[i;j+1]).grep: *.defined;
            @d[i;j] = my \v = @V[i;j] - @neighbors.sum / @neighbors;
            $diff += v × v unless @fixed[i;j];
        }
        last if $diff =~= 0;

        for (flat ^h X ^w) -> \i, \j {
            @V[i;j] -= @d[i;j];
        }
    }

    my @current;
    for (flat ^h X ^w) -> \i, \j {
        @current[ @fixed[i;j]+1 ] += @d[i;j] × (?i + ?j + (i < h-1) + (j < w-1) );
    }
    (@current[2] - @current[0]) / 2
}

say 2 / solve (1,1), (6,7), 10, 10;
